Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565A838C423;
	Sun, 12 Jul 2026 23:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783897776; cv=fail; b=iDA5dH5D/E2hTmKcNelP85+S3geQ1/ZExy9n38dC9+rvRSHnV2u1+ARTryn2PfE/6Ydh6gPUINSAwOMd97Qw8dR4ecyRGBF1TbUkH2BfplihRMLiHoG4wd0IwatcDVCWKRWi0PsE+uSxtg1nSrNrH7On5EiGDNPloxinhlf/yaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783897776; c=relaxed/simple;
	bh=yX8IMpmllvz4ha8C7kpsH37IpxZVmlCZlRgI1q3nn/w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RuQCeGZ6H2nEmDjycEUJB3RNKY6lSf/nDib0gmCAMdia56Y0r5oMQSws9dzEWY+UedFt0R4T3hKUFWKGpKs5WnTjbAz0snSdfdMid+Ip15n8+rexWyU/bk+wdJYFRo/mddEqKLI36vurYYFquFHtEwrRlt/Twe2e7VPr8FVN8mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LywXxxmg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uLkOe51K; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LywXxxmg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uLkOe51K"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CM7MID4155876;
	Sun, 12 Jul 2026 23:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZOcXREll+XHBXXScWD
	1Q8zm3luiS7+RRzi9uow2Jeqo=; b=LywXxxmgZ7nHiTup+YReEwo1dG9f2DGlUB
	N8db8693AFBmG0u6e3p/iDBdTazrpV7jf3pXISZJaV4Fo3DtXDzJ74ARrvLhh44/
	+JRidbnYPSozVxZHDzeXnKKpJplE02J55oFOKE4BFUmS61lkYU/i3m7rv0kYPn1f
	p5jVGt02PJRbrVBXyIKS/o5CXNx5t+AmPBh4a3KJ8lVaE0cmba7IFO0X4BrZZaXN
	W279UtDb7KLts4JOcbr2qSqZXPfb7hnUdn5+aRh5jI/ApSenVLaZPBR5BhW8SmvX
	qU+LZCx6/f3wKK1x8xSBRXygq+xvEfCWRnu3io2yI6Si5+L2GQEg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed81981-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 23:09:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CN85H0011240;
	Sun, 12 Jul 2026 23:09:09 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9c18y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 23:09:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uIdheG1dWDtZXe56o/hWGA7y+AKnMcHv7ESGv0MWyWLgxEEl6/nWeUTsFdkl+gFjG8PcS0FtA2Et8ahPogjelB7S9AvBPFwDHtiW4oY9XlKgmG2bMcXarXS/+8PZT/niKlIOIBzY7Nwq+0rHndzdS8rWL9w7BJCxJwcBHud8uzs/8udRYAFhoJU4dzC1oGqmCrsQPF3e/cxigJ2VE83FOyjNHUqOom3GJTbLG8ozDgAv5pZyNjBjlFV+Na5y1VqJaCnvu5Fq2Ly8LVpit8Xkj003OpNDgIzhi6i890+y6j5x2f7Dmk1idp3kvZEPXvt9vVgpVt080ZW4z6+IUh7NYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOcXREll+XHBXXScWD1Q8zm3luiS7+RRzi9uow2Jeqo=;
 b=vMaMR1UykwMinJvYuyz+jRqT31FD4LnM2QdEkDnc/4IYPPDdzeE5d6iH0m0XxMDp0UUfYGFkIq/crlT7aO1mFOjqu9v0XSRXmyRYjjasotKr0hoWqdNZ/CnfMrPS2KlDemv3mkLWSjkdymIeV7nX4zLqxfvBzglvgt0+kZYmF8E+am+DLKnh773ECrinVRCBPCb2jYNFnKtH2BooQiXLkFXjSbcHd0hoak4ThK+yflfpTlR5GzX1SMm44jodVn4vB6/fi2OpCLC1zD72tEpgrJjkPioogNcjr5GbFj706Y5VgjdAJwjvk9JYNDWhnbaASeuS7sHw3r4aeGQb4fxpAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOcXREll+XHBXXScWD1Q8zm3luiS7+RRzi9uow2Jeqo=;
 b=uLkOe51KYaT3QQfBOuehJzVnNNBwZB7y4Ygg6EZgGXqmQ+oygjI5lJX5eBhqTi/aNrYO//7bse90IcW4mbR3jU8IZ/YezWqtlF/5PPIbWMBaMJWU6VqytrrkHsalEzOuao41iaaI0wRjMLsZmvpVJfdqmhn/O4zNmUgrQbgdNBk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7233.namprd10.prod.outlook.com (2603:10b6:610:121::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Sun, 12 Jul
 2026 23:09:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 23:09:03 +0000
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Sagi
 Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] block: use integrity interval instead of sector
 as seed
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260627054220.2174166-1-csander@purestorage.com> (Caleb Sander
	Mateos's message of "Fri, 26 Jun 2026 23:42:15 -0600")
Message-ID: <yq1cxwrdgmx.fsf@ca-mkp.ca.oracle.com>
References: <20260627054220.2174166-1-csander@purestorage.com>
Date: Sun, 12 Jul 2026 19:09:01 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0193.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7233:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a330bb-77c4-4b17-4e05-08dee06a90b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hCdW6zirIh5sCpD2+anJIxte3C6Jmg7CWGsQl74fOgvW7GptkrhPDLm4feksURfEAR4U9Y1c66EpRvoWYLgP01z9Q6ZiHnSk5RpK47JoXV/rSuQJGm1ICO+f5kJOoiAprTv2iFZWPxxh5WNko6Bu0xSp/qMlrlMGQdE2OgVn5SQGQBC9ipy4PHWsskhhxUMwWQpuVOUWOQooezoKScph3nzdWG5lkAnWMXgzRYMz/+Ur51iTR9mtCUB7BhEIM790Tuk7uycmbvzyq/LYbOrQcRYE99+b0XC0IsLEikGcPuP7RzECDGcd8hh+inSlgb9MMOoe5I3/0PegtHeKNouGDkUAXm5HGZmbk8QyaYEiMIepW0Ze9TskG6ASf2abBgBw4Mpnu4WrOgP9swcVnuqDf2Ak5D0Ut3+UlxHZdHNxiq1ujJ63c4gSIclcUL8a4/swKOt3jBbbtUrk9oQlQDh0ArC+t4C7Jd1nCX/RGFIPkHgl+ff7u3I7DzD5vEPOTxXIO7eo4uno6jxRBhijzIiRVqfezckmHvA8mi3VRw2O2D+XxX6WBdls2uIY2xnjp/1z85y9xDcjyERQoVgjzgki0bVcMDLQ3j3Ez5Db9Fqxxrc5B+mUUF29Y+sE4GlKGalgos90Qhoi53f25mqLB4KeKqf1rIvNEOL8nR7uSp/0qIc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JphnC6/X67mXzDvHGfGDucyT+btLjcmIzSXI+X+zAmE7GaGqVvfBIDhS4wDs?=
 =?us-ascii?Q?dTuDZL/RIKyMbL9nMnfYFheYeE7w5bUHveD1vG/tfDAA/bL5oLp6VMvOtqJD?=
 =?us-ascii?Q?WK9nL1198TcvbMbnhkWl3yfu4cYW6NFHN3arjxFD5HLP/9BmIGtFMEsMx/vp?=
 =?us-ascii?Q?E92wnWMOdd74DJkDOi/L43xr/w0HVk0L1wJh0kGEGwo7KUhZ/NHYznoS5brj?=
 =?us-ascii?Q?Aao2OjAaZSsseMzUwTRkN30iWNTGZoBcZhzhBIzFCGAiA5IH9WkZgZ9431AT?=
 =?us-ascii?Q?lRashGLDcBDHD6Ij04hAHeXjPL8j3tbFlBRKoqjVrCidEwu8Wa0KXRS+YZ86?=
 =?us-ascii?Q?pjdBkFBb7LDvopYygRrcQUd58gt+GN5+Zy2+W2iM9blQOTlNCfbRpwxmBZo8?=
 =?us-ascii?Q?+HUcjPceK8sdGuPd4wB3VPBn1U7k5SGz9dHT0JFEVR0A0lMBMGgxaRf053ml?=
 =?us-ascii?Q?BUWmOgjzMIjUF48mmzfPq5Cay89JyIVPPqoe2qu7eYjflmc7ezSIUlGBhVvz?=
 =?us-ascii?Q?D2Q1zPULPtWo+HPLyNoHI1RvZYqUdb7CfaFlFKLK5oZh/JJznznUTArenkZW?=
 =?us-ascii?Q?maKBthnPI8cqCgd1ZoKggGfWTmlYQeaDVFMhN831JQ8frIVzUweIFVP5H2Zt?=
 =?us-ascii?Q?xwmU1jxeQ5MENL1WucgoqMmsXuuHCrfB3NkGsZUrWrVFHrM8t7DpYslhqI4i?=
 =?us-ascii?Q?TdDjah0WaGfmnI9T3g/xpP/5tuUL51aAsW4Y3MpZVwV2lbwsPS+6wmxf0Z87?=
 =?us-ascii?Q?6bbplPRos8+Owc/AFfQC1E0DP4I54aQdVL83csF2iP7LW7hQmFDtaRY6U/Xt?=
 =?us-ascii?Q?UwZ4gynqF51UK/yig38agVRCy3aeDBl4kkAzFN+VHeTAw22GrQ+JnZfY5OyG?=
 =?us-ascii?Q?PI+XBPuWp5KGUGx8OYicKPCeRoWSns11BRhUIThxkSU1a13zUuTw8rrkTDKY?=
 =?us-ascii?Q?cNoqVstJBOJoXI/T80nP+rk2pE3NQtjV9cnarjKG2mIRcP11oqmnPhtnYD/9?=
 =?us-ascii?Q?ruDQSlp2YxBSTlvoHlKuHgGEK58XXyqHl7y7ng56AcyMfrNFEg9ok7wVkBo2?=
 =?us-ascii?Q?zxkqbMZ4Trxz9qwHEsbz4khHMiTdWfeSHQn2AWfmZfL9jZ1zrCNwqZJc0dMj?=
 =?us-ascii?Q?Di7yVxSeCxzazzR7aYomPlNLbQGYBExsjgXzYzOKD2jGF6GR+RJObXXTS2+b?=
 =?us-ascii?Q?CuWOIx48kBzEFYjw9/VqntXVaSwk7lmqSHRSkFu5yJmvkZjvopqkpR+X4/49?=
 =?us-ascii?Q?VKlpdJGgLgq8kXmZHqOC1FEpbrg9yPW2bjKSoMh//HZnaeVzdw2qSgAnl/tk?=
 =?us-ascii?Q?N68+Z2JS87Z1iXoMHqtEY1kfsRgOIfj5LA1QExuMkUt/otxBw+8SjoVEJoh6?=
 =?us-ascii?Q?yp871h4j/QR9BdA8VjyyE9SRoB5krZvFa6BWBWiDJz6NhIYgpiwqqXhxWVSu?=
 =?us-ascii?Q?YTku2QY4MqbPhfrNXKmZkWMb9T3f7U9X0139/XaidfRdANL1jyqDS5OqYXMz?=
 =?us-ascii?Q?aPO0Ej23sSRm7uGzpW0tj/CRTV9xRu6t6SpAsadgAxaY97E0iYC4XDe2b1KJ?=
 =?us-ascii?Q?dMD+3byj0hN01iX5h3vsm/i/et4LNkvtlwqKBWUqIFf/3YGplZVgoI7irRjU?=
 =?us-ascii?Q?wBmVwEAHMLJZxSd3iQVQdONNaXlhf4nGE86o+3DKDYzQRStcYFurGdgHCza7?=
 =?us-ascii?Q?BREujSkiqeepQpW/EvE5iU/QYr66YpSvk8c9NT3C+utYKtzB436A3Si3tpvj?=
 =?us-ascii?Q?Z3EM4cdeTJ8jDwrLtauVX8uDTE5bWXA=3D?=
X-Exchange-RoutingPolicyChecked:
	Q9xkWkFyCofzK/ntGma8sdvWTAdUbqo05zoZ5RqTx0Tgslc5o/n96zPIwmgKEKwhn9yiobYE8uP3UERj86kwjBpdMVBunv69WdwCeyxJTMsXY6lZf46QOb7GbkLbHqOewljKH5/rILRnLeae+9ZfB+vjdhtsvK8tud6wgGVIpbmwaIJxpzeO3bQjvKq2qgt+q9V/l7+2totMaowtQyiimtWxmXokPQLm5wxY65keDNPrKlp5pN0CaZL0TWnQbXbN+Q8ZbPhHddgQn3PGZ6X5ZfwiYUb892IdeHLSeQPkbcxhxAziBBlN6tTgbAIOSvIv/OZhN3eNE8jwx+3A7+rN5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jb8Tf1yCNpEHMXlHqDjmMMV1O10Zv7gEmLyBprIs3Tl3iq5SPEQJNh15SmI31r1U4Eof4Yic0Nj5XJuW383FFKt4arPbcMca3vt/k2gkey5SB7jutNtla/sMdrOhOFZXALn8jjnXheesjWjEhcCy2dXQtD+qzqP6akcqq5QE58XzFarioZ3HxEHixzikfrIIDLeHeQDAY1nedsDP9SMPpz+G+m6JMY8U4mYjFxExjRxZfe0CckfLQkyLKfZOH9B5pk2vtoZOi17HqAz0e9+tcAzOrVyjwi5JoQwEgFo8spT+xtXjkCuz000/CiGdb3oMgkX08Xdewk55mbF64CuvyIpkZxUsIlzELmk41oUrVNN62UWGQX+c84r4Hb09nhAOWqYGgs5Xoi5+i7sYoG0SgPObshs3LJDvtmddMFwiAokTQaKFeKemC3NQj3Z+H/O+71IlaWF5c+9cVriB2RPxQLeu9fF8AKWKvRiZh+ixiLMMwFHX6tjYkBiPMrSS7tfnc4nkgwlHh6h0hoSnJw5gsdKpEocDQjhLkGfR1BZM9uMIDjyMxShtJZFTI5h5kQQsDsNCDa/LT15HodyFCyWv/ZsMX8JIFxO9CwEgV6Z9aWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a330bb-77c4-4b17-4e05-08dee06a90b0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 23:09:03.3767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olRK3gLm19fdrA4vishYMdM5/gKoJdZi/inGavWBKCv9aNeNqWH+TiywYcPBYJsOf+6DD2HZXLBVGloP1TIrUd5iLLxrDEVzAviZR9wGTwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7233
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_07,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=697 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120251
X-Proofpoint-GUID: 6lpz-P0ZtVyccsJeyoE30wHGEibuVnSq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDI1MCBTYWx0ZWRfXw7P/LQqjWX/d
 /kjqVM73qrr5mb+agOmHVokIX8U80r5UikgMN7nFSWcUS+kGr+TDHc0DMFPDkv7ANNZq4pIGoMp
 fkANAezyiHsUj2twX1Dq2aIUpq68dCaohX2V08NqKbEkmLfvCRu6
X-Authority-Analysis: v=2.4 cv=JKALdcKb c=1 sm=1 tr=0 ts=6a541e96 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=S-WosWXpVsDzJHGSFk8A:9
X-Proofpoint-ORIG-GUID: 6lpz-P0ZtVyccsJeyoE30wHGEibuVnSq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDI1MCBTYWx0ZWRfX0DOX0fqB3sUA
 uX9SqD7K/5+9r2yKMRxNUEsoca3fTksENO+dJaD3Nx7FOC0FgxNKqo38cNT4Ki0Vgp9Epw0p8b9
 gRA+BCDoNJ4XydJI7YQrvTI+jKv3IIpiOacIQSMiP1XhXVg2Lu+hcqjzbyMb9j/UCjonwlYsFOl
 iwZWY8rlnYpBjoWHaKIlDl9qYqaSuSXQ+jQfQgLRReP0W0vfmqIZl7OfJb88kKUP5xs6GgMGI33
 S4ZqA2eQ4pETkKQ2aEc3S+A8bk8bbn5FzMI/OrAc5BD2zKsJjRkbDDeCPhp1Xpdlbkql2wZbamG
 yavTDRux/eCUnNPXV/gVD/cpVFZRoj4WG6so4XsvUoE4r5ZGYCMayQ6W2vkoyewz+u/S1qLbiFH
 aG3VIkFHa3UIoUfZoKjgX/JhXUOT2R87xflpLQAtkxUfsIYxXbt0vKrltnWzfYPPgRIIziHBlnA
 9b/JwjfvTPBHNZ2ezqg==


Caleb,

> The block integrity layer currently sets the integrity seed (initial
> reference tag) in units of 512-byte sectors.

... because that is the fundamental addressing unit in the block layer.

> However, Type 1 and Type 2 ref tags are actually in units of integrity
> intervals.

They are not in units of anything until they reach their final
protection envelope.

> On devices with integrity interval size > 512 bytes, ref tags are
> seeded incorrectly.

The bip seed is whatever the caller decides it should be. The integrity
interval size is irrelevant. As is the destination LBA.

> But REQ_OP_ZONE_APPEND operations don't have their ref tags remapped,
> so the ref tags using units of sectors will be stored to the device.

Then there's a problem with how we handle REQ_OP_ZONE_APPEND. For NVMe,
the PIREMAP flag should address this issue by remapping the written ref
tags based on their ultimate destination LBA.

Fundamentally, you should be able to set the bip seed for any READ or
WRITE bio to 42, regardless of logical block size, and have it work. If
it doesn't, then that's a bug.

The fact that the block layer happens to know the start LBA or ZSLBA
does not mean that callers above the block layer have access to the same
information. Changing the block layer's integrity handling semantics is
not the correct approach. Everything above the block layer depends on
the existing, format-agnostic, semantics.

-- 
Martin K. Petersen
