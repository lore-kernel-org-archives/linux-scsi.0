Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C119D071;
	Wed, 18 Feb 2026 02:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771381040; cv=fail; b=TVyKlQlXPJ8eGPJa8bzm6On6HR9xRTZrY015MQfFYRyiAw5Wk6N4fWkc6Scps+yzHSjmzntmhkxP9cUSqt1wohHL/5HG/xT/umdv3BG1O/yMza+H/cJBMxNhK3SyYdx7804p6K7Facrxz0UvjySMKnKcsf2LYcixLLPolzR6MRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771381040; c=relaxed/simple;
	bh=Ac5N8KDvcMayojAB56qGjWXmV2VmArNbz0RjWn55XBk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=K2knzeP/kxLzT86XnkVhdz1ZcEitbFVYmzC+tKWv/cq8YApG/HEzfsaCKVUrHHsvOYaysivDAevgxLZLK2+RXrOrVnubstwHkI8vn+inpwi2GuARNgwKCP7zgoV84fXfTg8CxAvlpmeomQzqVz2cQ4MJJvzeKFLrOwOZPIfO4x8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cUACvUCv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sxN5jjHQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cUACvUCv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sxN5jjHQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNSjN3789102;
	Wed, 18 Feb 2026 02:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=D+edtH6huyCCyn6s+b
	uadJ4u2khDNZV+LiRpM7FGeUE=; b=cUACvUCvzpPVFQ1kCkmR9P0iYuQgKK3O4h
	r9TSbu0GypETbsOv0lkZEVREYO8Tr/mQ3xlzL75v2elCAcgWCs+ywBWJRgWEZ/P2
	QQl8ZhlLuUS8AHjJr6Ap9YwxThLeM6BpXmNaZPTgWIHy7b260y74DIakq3nFSzu1
	XGJ8Npngrazt2SvqASjHd2yw0g4mW95Luw2v7mRHxMy3H9KRslyml+RO77QyTrWJ
	ayJGUPjc6mq2Umhh1Sl6+kbpHw8M34f1rB7/hh6YBuf7XSeMHVlS3yEznDGpVypN
	RNFAMOJ077/981LYwmuJMJuoAKhL/FX0tBD17zKMdlM4+dsxyKJA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj5r4shu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:17:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I1vIQo037164;
	Wed, 18 Feb 2026 02:17:06 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2814yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:17:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WKMUi3l2lROjWKDb+DKO2amH96caT836CTfSxwHCwQ6o906eQYWOOi1VzGF/B5TvneDWIzsBz1ObI7H+8TAVtg1fRDDaPuSXXXgJH3Qok6BIBBRaAupvnnYnB/viwHetqSAt+iHrD1Dx6Q6fqsYYUgZNkHMbnl2Fn79PpjVhA52A3G23cWYWGUj5WaIVvJi9jNtpzHCNkvSf8hWBImtjQi/Dw5BttghVu443lxbTckeuxAecI7fYZ01dewZOQ2fgslOpxGYeEwtZqIgkZZDhrWjrZfMm6+/9DbtSTfJw8jaPnz0scqEe85Uqj7HjEOfQUQRlWElQz1QGEtjdS83DZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+edtH6huyCCyn6s+buadJ4u2khDNZV+LiRpM7FGeUE=;
 b=QE3aXnSGilGCq8Ld99hxShnnoVRXbamNyARPdapjPGyHlMUqVD7rW1Oq3cIYVLFciNVHG2HgEcgHB7jtnmgJ/LR5EPUiqw2cgL8i4p9SgBBGVeEpCoVT6Ua1BfuZpIl14iHH5907lpE63dTHaWdKYKkBoH2+tHkZPE1Gf2Dka/nDDGP+BIWR8rs1kLiroUFKXUSkbIH3Q/eKArJegwwWozTpLsBExEpxv1MdPNRGuV0s3OVlkHDiYNnDR2Fy7K9O6dGVLnaM8uecT6WHASdsRstcNFFp7DW4dCNzJL+kASBac/vgmOwH92GhYuzB4NJOaozxIPBllCWLqOyIMus2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+edtH6huyCCyn6s+buadJ4u2khDNZV+LiRpM7FGeUE=;
 b=sxN5jjHQDIua5hT8XS9T3kbxL/VAxxF6TUHXd1EeSLfD8ko3dmN4sJn4Xv4YXFpLkwXAfyYwt62kDxNMeZ2wAV0yeKrZmV9FLaOSVM/05G/IdP0IAI+pjqoYGh7FU2ka7S1LHHjHACuqk/o3UkrBxxIlOUKI5wkPkPwkApVebYY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB6769.namprd10.prod.outlook.com (2603:10b6:208:43e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 02:16:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:16:58 +0000
To: Alexey Charkov <alchark@flipper.net>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo
 <can.guo@oss.qualcomm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: Fix RPMB region size detection for
 UFS 2.2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260209-ufs-rpmb-v3-1-b1804e71bd38@flipper.net> (Alexey
	Charkov's message of "Mon, 09 Feb 2026 19:17:34 +0400")
Organization: Oracle Corporation
Message-ID: <yq1wm0aeqy7.fsf@ca-mkp.ca.oracle.com>
References: <20260209-ufs-rpmb-v3-1-b1804e71bd38@flipper.net>
Date: Tue, 17 Feb 2026 21:16:57 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0019.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f392840-1286-423b-2e21-08de6e93cb8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i9ruh/Ogp+1QBBYS5W/WLZMvJml5VJyOLGS+oz0HRVyPpehHid1pDDLIcDo6?=
 =?us-ascii?Q?AeqcWqTTMDo1dyaYwdEbCf6xcETqOwp/l48T/IkpYWisioegB0KtiJWlbKl9?=
 =?us-ascii?Q?oONknZnlpCQvAy+P5No5AFpvg7nAzf313hv6iFqkCxAa3FfeQyYEyMUhM65/?=
 =?us-ascii?Q?jl0YldmvxR6OAW8fCZtrI5gv0rDw8QIwm2l0vk7vQPPwpoAsCnpRUFcFh2/0?=
 =?us-ascii?Q?0P+e2W/7ql3FeeqV+qHSdpRFgfT4ZrubmwkHy8w6bd06+hALehMczzFq2sOS?=
 =?us-ascii?Q?FYQQ39QszbcaAwXAIhgSC8t5gpaxkbm1JhDIY7Fw6r18bjU0PO6Aq7pRH8nd?=
 =?us-ascii?Q?0rMp5wZeMLfmgsYaGfu1wcTrOfXepgUGOTlpwbfFq75SfaWsM+W6+cWOJl91?=
 =?us-ascii?Q?FDkpji8tFr0VlItFLuyQ3WA+tUPW3KvP6KebR7jlK2R8k3Qqb8Aoa00qwdnL?=
 =?us-ascii?Q?KdfdqViex14DMWMGpm3xsvXjqxS9IYJJS74XBr30HgVYdLxFwJypmAeR04N5?=
 =?us-ascii?Q?xxd9nHNw9KXYa3hdzdCRfiwWyTZCElnnT//EXD9htKwL6x2eSCkYGXHQH7IF?=
 =?us-ascii?Q?eG9hjoreTDs8h2ko0rEAyxBEVJDbIlJm10Idor1ENPPp2bCCO1pSp/7xfPTX?=
 =?us-ascii?Q?3I4dN9yTGDQY08OlbKcQ3ZEmBDnnCPwcc0/IHqSEfHheTd99GXPq2+VAFqrC?=
 =?us-ascii?Q?pR6UUe1d8+D0BVJ8onxyM8KaDze6eoNHQPbJ5n54A3fvYGVCjrTJ1KmKmGo2?=
 =?us-ascii?Q?Xc2F2FNLKrQl/znCDFm4Sol/WZX1Sjwupjm/RUQ4PsWVpqOg3n4w0eOQUxx2?=
 =?us-ascii?Q?cCPAeQsuTtuR+51BqZ7WE1qpjBmXbq5shfdjyCFgchhqntdqUavFIZFb+ssP?=
 =?us-ascii?Q?GrR9spQ8TzAuuybLIJWEZfiDbiTk87Y/fI6nxqHZb9LkyjJyJLGRSRJznGdP?=
 =?us-ascii?Q?sCWePzBJ+tZ0QKsJulFYHHQZNyP0BkEEjVRhUEgWIYURWVNy3+MCR23trmn6?=
 =?us-ascii?Q?JY2QD6u0ruM/H5x9tagbzZlkq/kwXWR4jpUFTFiqRLQaH7Mzy86R2vwSPZ3A?=
 =?us-ascii?Q?ITT7vbaAu1HWoALf2VQEgDaM6TXEi7AFFwt6yubdbtVph8XdJFRYHkws9wzI?=
 =?us-ascii?Q?nY8pJWweVE5pUnyyaGzPdF9K6M2NcyeOI9LG6QJHCX524ZPRvqImQk4UxDpO?=
 =?us-ascii?Q?j74WVG3TFjEw0LZp9GAyLrowBO7CoiZdRer1ybQZEwD3vyCsq4YS406vBxV1?=
 =?us-ascii?Q?vJl+z0PtjWVRp7w/9yw0xzh1s6l6UU8/mdmBY3WdZVn33R19qVrVs63zHWiU?=
 =?us-ascii?Q?eA9s5uPEbUI1W3DuQWU1ORsQykn29Z/nA66fUeoXZPaphrIkUZ20Kcvw31Rn?=
 =?us-ascii?Q?QiaqzvdvQYLplKgr5507Wd4hC2ynKNhsa2+xoKl3HDefZn++xBanUp5SyF0P?=
 =?us-ascii?Q?GzA4WUctQsUuk90nUDKYglQynDfLsomDjKNhW4OHMahEk4fwe7PWaSI2IU4f?=
 =?us-ascii?Q?KZ8rj2AUSv2691sjtKXprZEFqbfMx3Q/rOvZPHBef9pFIJqhqFw5PB+lOtHo?=
 =?us-ascii?Q?odGqZQ/H6r1NoR4B/58=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m1tYPgChNFG8wpCdLLhOSI7Fo5yT5a3lyvgaLWwIy0eE/qsLx9bYLuruPv+w?=
 =?us-ascii?Q?mhqlkEYEz/Z2RU8lG+c1+7IrV4mX/rcTZmMQU/LMe5NmDdfTdqjZSiSjtzgL?=
 =?us-ascii?Q?WCTIo1d7sa9YXnSM+afgUOfZJDAvOnKax4VyTwGM4hymk1JimPfTc//aneKA?=
 =?us-ascii?Q?x9RksGU3ZoWMhCvcmREjp5rB17rQ2x+9cOyeRvjWUXDr+XxW9vo0rpGoqQVX?=
 =?us-ascii?Q?Gckx1AcdVxVikVMakaS3ds8Z6TWKb03c59/bDfe8FYAZpHnNjHFqmgnXPftH?=
 =?us-ascii?Q?LA4p7zP7Snwe7pcMA5leHYtm5XVdr6R7FzZI3ttS0h1PND1t2SkPc/ofPtnj?=
 =?us-ascii?Q?0R3q4JT7ZuhSStz/HxS5dzzPut10KckSo0dI9iERj+Aa8DAV+HOPp/s10yWj?=
 =?us-ascii?Q?vkApyTVODxzpNJqLCw80oGJ9lQDnAqNaKt1sel22+BvLgK/k0qjtHbetX/sG?=
 =?us-ascii?Q?zavo5eIOmgqjGfl9DqTihJdwJjEA4ru+ahxIgAG+L7nlTVqhKyRdpDg9ScYJ?=
 =?us-ascii?Q?kPprhWX/bCRV0zHGFlSW7Coh58HmsdGYOc8QjarGNWt0/O8dTNg8Qgl8fEtw?=
 =?us-ascii?Q?j8Pfv4kH/ZNWODjepHGa78t9XjLQxMOPaBpO7LIMpoxe7pCzZV7Yu6HtsJZ2?=
 =?us-ascii?Q?EJUMpP8s/wboh6BxbANHMzdAze+4oI/zFYmR9vtEv3EsGi1pkxY3dm8brXCV?=
 =?us-ascii?Q?CO7B5r1KjjaBKjbPLEQGFY3a9Ysy2jBLQGDt17lCvVpU36d83mSUHqpe6UJD?=
 =?us-ascii?Q?y0qjs4Qp/sgiSP0CQvE5d6LPhLUuHR8HUtDMQnNcQhO4I82LLyFh9hQhK+u7?=
 =?us-ascii?Q?g3+/YHC4H05I/n2olN6k20r+NSP6lg2S4QoP+DWL6uGWcl/XWfhZSdch3xxu?=
 =?us-ascii?Q?bRimNcnfw29y6XU+ReKufEikhNILMIFoCssJEEp2a2Deh1MOwbzpnKsd2dQS?=
 =?us-ascii?Q?p/ImBr0czBosLSL6H6TPteSSilZRM5B7yMnQGuXo6BuwlZBkFDHCyv3Enjqa?=
 =?us-ascii?Q?zKpn5nzyLBbLCbalMTozzU+C49RS0fJ23TXxTzG9NLjjM8xMQDouokIp1NGx?=
 =?us-ascii?Q?kMtKkxY20d5dRUYlFeLG3bsknL5n+H4FFd1j9405zvGyKHvut4lXujLLuCyJ?=
 =?us-ascii?Q?D1P+sIs5eI3J6zmslFdrOGSQtI5jvpbg6nSm2QMi+OU/lZdt9nP9pGNiyU1L?=
 =?us-ascii?Q?HOcrvQleFIonQ6Be38whhybnthcOheRzbytf80n97NxxtwWpsp5hEvM0p9lK?=
 =?us-ascii?Q?bPpwVlWfcK2RuBflF47v3Zn3vXLGuVTELC1gUukylFrVnFBNQ+EPUOs6j9Sj?=
 =?us-ascii?Q?f/0lqVK54cDnCRVVotH2UFCkXqoVfwcEaGzNPZZsgpAxKuYrh5c60WmMbe+k?=
 =?us-ascii?Q?YrDS7OJRNjvs4jJUtaTuYxc8/3HdcjApGIfdf5k3Z10X/DjZqXLC2TA3Fjga?=
 =?us-ascii?Q?2zgcDZnQsWrzMfOD31Z6fj6aHBQxo9Z/q033P3JyybWwh9b5vowJ2KlivHnX?=
 =?us-ascii?Q?djSwSJDrmhVxOVSVN+iqew0duWIqRjPxLTw8oZxc9flbrOeIAWb40CBe6yAR?=
 =?us-ascii?Q?hB1FpHNHxRShVSDrCgF43jJv12A+D7D7H1XCNieuL2vXziDvx6+EUcb9RKLV?=
 =?us-ascii?Q?NRaWErOydhzneCPaX9OvtwWyj5R4epgr5bo+o/L0h1r6iPdKj4OaYXOU0SVr?=
 =?us-ascii?Q?wYjeOorNXOlCj/8pGIjqrSKKk3tJ/k359QoX9nugwdHBa0/d+R9fbPtwYNBF?=
 =?us-ascii?Q?xf7e8ZI4OFF/yoEOq+Ii1OKvhcCclKc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3NZ70KIS88eLhTGwpa7tko4TwXp89UGV5SwhoI2O82WLO56NVQVdjRnUGXVQIXgFpyIP8cDC7bCA7YekqOwYddPCZLkX/BJpkSOxM3dipLO3rO8EpP5uq2rCZ6G411FcFLmMCywNnJgtawtsUybxOf7S/9hMNN+wIlt/WIp3GnnXSoQSSyw1qQnO3c1U52dIH9VkhRFqnC1uD6GpokVf4f1Ci6C0cnV4jdCTu7j4AbE4MAbYyXd0TPK7rQMESvbfv5pfkDC9vIJ89e7sldDR+U/4wBDRy3sP0m7J8i4R56LfsBeCr3XVgmjz9XhXaZp32g+r7LSeJKUrxvylwI0cETSpU2QdL5uud39GEzdUn9qamK54aRXTIufMrGd2pTLqpR9AUbeN/356PNYrdYwQMN/5bjdennnekzxMqjHtVRRBlUzfJHDDuTRZJ3tI7qponT/FhEKXSckCp21clLsm8fM9nzcDv+5smlqbDAiqsNlg60QP6IDJxLkNKe0UqMLOkuiofjxfFGSDU6B26jS+L13ErD1Udr3roiiUBGIG2fEVHtwNYeQoGB3rANDl2GHikmtzVbdCqhkrfS9MFBZWB1fIChkuYs4S+0cpaRjeRBo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f392840-1286-423b-2e21-08de6e93cb8a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:16:58.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRoBFLs4JTf9y2xeT/oBwb1pu2h+tmE4Jma2XpTAe65PxNh2U2jMbTUCsz7dXxNPgLKxE2qre0KaW2dHZMrG1+yB6K/kp9glTGc5Dce1zTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=720 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAxOCBTYWx0ZWRfXza4h2fARgQ9q
 KLKCf3geJZm5XvtFJ0MDWT+/QxYsXV3S1Exd68b4/QATWemdbVXoGJGCI9Oclc19vYRTtu2d0k9
 IqFrEgBmJGgm6ybycg/8lK6O3W4FJ3kDIFwmplMUFgKONZc5AKnQ5eDkT7+bXhi5v1gbi29ZN0s
 wyge7z5VzMrBqmMqvjA2rJkqoenHpDwJpdxtLWL2Sgg68uso9D6jAdM26vVOHnpoDX9ZkLvOgq3
 3XxW1dFU/LbZVTJ50luB5gZHnH4NfOQGBORekV1lNOai7EJIFDh0qWr84FxL1TGCWg2LjvOnhV5
 SjZRSE8bgBYuRSibvXFNL8/Ne6pUbb9bRLF42MSal2pkK4KH0+0JRPjyM6gym8LfIyLRh1+qLpk
 QRI1eBAujIaQXEOquJ5jKvx4XDM9+nCJCP7Jc1ythng4nyQrV0DgPw5wIFFBoLeWgpf4tOEaw51
 Dg93e1NmORrOWTU2McMjZvU9wu/or3Z9vVxLqGOs=
X-Authority-Analysis: v=2.4 cv=Saz6t/Ru c=1 sm=1 tr=0 ts=69952123 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=WpOT6c3oHlBwd_VzIKoA:9 cc=ntf awl=host:12253
X-Proofpoint-GUID: UvlYKG7e9riCXOFp3zEaGwn96hMN7IsV
X-Proofpoint-ORIG-GUID: UvlYKG7e9riCXOFp3zEaGwn96hMN7IsV


Alexey,

> Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
> sizes, as only one RPMB region is supported. In such cases, the size
> of the single RPMB region can be deduced from the Logical Block Count
> and Logical Block Size fields in the RPMB Unit Descriptor.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
