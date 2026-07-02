Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B823176EF;
	Thu,  2 Jul 2026 23:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783035752; cv=fail; b=Dh7r2TAOWHzNdJajR9YVk96C+JACxmRLLPzSy+7e2fEzkMS9xJLkaC2Zx527sll9eSK/zb5gRX8gHEAvKl0qYNjOhkjuGo2IP2Y9tc7XGbYA5weSvZZSGDkLZ0fPMFDb646vRnLNw0LFG9drHE714qEdH1qqNWtsW/ML/Xy9ihE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783035752; c=relaxed/simple;
	bh=t87kzcKBHapzpzXPcKdis9WsIfLLB2uJniBUU8JPUGo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XosBxa0TMaDXIcQhnCQI/GcQrTt7TDYVrvdwcKbYI1R1D96JQP61ojLu/ySs6/8yzxdlGGC35tK4XcethJgiFgjbK0Bm4us9m/0jgHF8aJcAtQUdvetQk1R2XlaInkoH7WMzYUpKvJXPdc8f6B73VgfQ1YjjirJeYlVq3giGrT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AmUILLWC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AHN0ZzeY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AmUILLWC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AHN0ZzeY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662LTOvx909421;
	Thu, 2 Jul 2026 23:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=s0aWwp/CxxZSiCE71i
	MoX16SuYkp/pvNcKY0Jyaw0hM=; b=AmUILLWCsvPP3CZvOh2Q0WQqq7qmA4KVUS
	NquFlijIM9o/ZSlQllSflA3IY8DGw/hfe/Ix9iSfe4CBOc7NV5bZ5gTeHFeOGgL7
	dewGB70rGd0OXmeyAGO9TXsmS+0slSvugP8Ir4j+BiklZx8jbu4NlyR+hJ9hpYPi
	Mrkw2oMH5FUQ4OUyKMuE7QZDO36+IT1pmsnNbib1e4HVa1WA9VwKSFi7M0z6mOg8
	/LgH0SMGqc7Ft1Nan//+aVLfQ/LpqrmrJgsVg3jPG+6OifLGTlyooLr7hc0MLjUc
	JGyGrnSOsAicHWECDEWTiIGiVgH9H7glbix1gYmHGqOabZpirKsA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qsa94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jul 2026 23:42:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 662Ncbv6039991;
	Thu, 2 Jul 2026 23:42:00 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012071.outbound.protection.outlook.com [52.101.43.71])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u1yxy90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jul 2026 23:41:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hvXiw/yvvmr/UWJHUivUeLSnoYPs1kzNrc5h0LB91HKa4UDLG1jeuyyGNc9ughh8TGi5fZObK/J74pXmtbN6DJWLdgL7DHePh57ncyg3VgBzX86VC0AUncQ7l+3BNSDj6zscz8qhkNuvG9WKxQNbGl9SPgZINzujaccf6apc0ccW27m1Vv/UsX1Pjz+ZgK48ixwi9xojmGyyE2JPAiR0IJHa4O8QN8Hl366kGGfuycp7uz0BAbl3nWqSOI0J92yaxIfATqn7f2lKMWeSacokV95kwCMheNu/OycYhMMak6NVni2JM22BtkAVUkZuaS3oVvmOn5lEQzMfNUNqw0iUAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0aWwp/CxxZSiCE71iMoX16SuYkp/pvNcKY0Jyaw0hM=;
 b=A9TBL4OGea6l3+1rxkSyrR5eFZXzksi+Xwotlffh1iK2SDCHfyvdIe1uVrucBjIHJN6XBf5SgcWlO0CneaQH34YvhcEuSmw+Nub5pfLXIAdd//Og7xZahFqT8NfFRgtszF8MP2a2j1P4B2PqguY/orn5atM9Tm2ZYQvXgga8uLh8Nv6guXUtSTvS6QGEhKU+2cieY+aJAWMjiYDv0c7EwLStW21aqJs8HS8K/ra9S7sDlQUcz9zK62h5Rql6fR03es6vmoniOGRLWmfa6axd3ln3ls7atIH9I2veqJ95NhdLGuJU/7alJNCIHk8KBFxMvB3pRehxiPqYbipaYT7mhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0aWwp/CxxZSiCE71iMoX16SuYkp/pvNcKY0Jyaw0hM=;
 b=AHN0ZzeYUAi7i+bQJhlOtiW/+WeAXdJewSsn75TV8bvK6AJLFHtBrAVYymFRhbHidScIBM4LKJ2HGC6AX+A6gsoKa4pjMEDQoZ4/RSsQQCwWQkIck8t/dgDBpNokAl8a7uy+x5ID5T8Qm55F1MweIOfDBalZDjTClmNCq56kw/U=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BL3PR10MB6209.namprd10.prod.outlook.com (2603:10b6:208:3bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 23:41:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.009; Thu, 2 Jul 2026
 23:41:55 +0000
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg
 <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 1/5] block: use integrity interval instead of sector
 as seed
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CADUfDZqE6JLLbugK+qYe=XFSLV5zUwFEQ6qRqvJ-=uVs8OtfVg@mail.gmail.com>
	(Caleb Sander Mateos's message of "Wed, 1 Jul 2026 12:56:24 -0700")
Organization: Oracle
Message-ID: <yq1ldbtm025.fsf@ca-mkp.ca.oracle.com>
References: <20260627054220.2174166-1-csander@purestorage.com>
	<20260627054220.2174166-2-csander@purestorage.com>
	<CADUfDZqE6JLLbugK+qYe=XFSLV5zUwFEQ6qRqvJ-=uVs8OtfVg@mail.gmail.com>
Date: Thu, 02 Jul 2026 19:41:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0141.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BL3PR10MB6209:EE_
X-MS-Office365-Filtering-Correlation-Id: a22505b9-aea5-42b7-fba1-08ded8938021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6IYkoKkAeBNxZbvtheEP7kl0OjcXtijPupQdKT7u9O+EdQFt3XS9FuTXfuIQriMPgYoIPPozzWw89hxlMqr3yzqzrauyS4QZsi+CnAp19hxEbhdS3jsc/PolDHCyhzpPqC0ChpAcmgAVebvdBJFVJ7/SZMDCIIGYGIu0JsaunP93cJHiI29EsMuzmEaV/Za2Hoq4nSo4D2B76NzJg/DT3F0w3/th6JAFVRFEc1CgBYkgoz+fS0IjdlSyXGJsXm8gKMQ3l5Al0QBkaNiQ6UWpDBzIAY9Du6SDZDZ48TMLhIJtraPgil2bE3+DH3UEw7aksWwJ+SMZo3+Ttc01wdQNjF29KEJ9lyQiq92RUbkwGrAR1hsqS2QTQcPfYOSiB6L79zpDc2/OmWGdR6culk67fA+eAWUyJHcQMsrNc7Ean7tqvvWPcvCU3jtB15/yvHH1z0xzN0oZra3NbquxxipP8ADXeuuW1eOrsopiq3gmrFSA1mt5O5jagIvmw6B2iR1SILBj+HIUvFZAg1J15kTxI5Wh7yBgfCAu5QjamzzTRZJhEhH8c/0FAJDWS0jusdAASDVQmXGUpyZjT13pwMs7kEewa/XFbk3YikecLOxbSh52b7nvexkAFhfHWHVLXMjRftNuXna1uDzbtn4AybQzj0yfPKPcWeyBqstBx2grcFg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J2LVdHQVHUoU/WD2g5q5okRxUk5owaLI8mKwZE4ORt55WRzd/nZIPrp+Yofr?=
 =?us-ascii?Q?jg8bZ1RBkYRB6Gww2+IuxqbX74SqF7rSryjL9GaR34MvIcQfMWSES5QLcH7L?=
 =?us-ascii?Q?1YM/GpJw1GGptbfgX/P7kLKstqzVTXj87YLV6DwUEZXfmElKxfn+0C6ZWRCp?=
 =?us-ascii?Q?c349RZUN14Z9Z+wU3qcyvA+HMj0ejznI5UhhMYZj1YkAH+SuQLp8x4FwZMsU?=
 =?us-ascii?Q?7W0DK1Uwy/PtlnPS6pAbKBlLLFhZudyZcQ2LJ1ZAwVI8zwF1bLVDNaR6rAmY?=
 =?us-ascii?Q?eS4SFHUMxZmnE2OUSmN1jsVJ9bJyuXpXBwFuBnTdXjzAP7LMISnor5DHC2MB?=
 =?us-ascii?Q?FmIq0fSGV0soO0D7ol2mR8H4Mz2pynsD2IYNI3epF1vyW+JFxI8bUizokLO/?=
 =?us-ascii?Q?U6+bnihzhb47WyG7Wxr1P4oND/q68Wb9TxzEkHmSZmlfC92iec7ku4fQB7EV?=
 =?us-ascii?Q?d2kccN+dNhNwDKhrBWQvaS2DLLKrkrOLEt70azMdKW+l6sf6ASfQQ/3DS3dG?=
 =?us-ascii?Q?Pb45FBEFbQsZk2IZoK4bK+IyuzFuFwRqRnzUe6Aw00vh3VaHgoGr9SY9HXuZ?=
 =?us-ascii?Q?YtuQki2cdjxurHBxCVl6aiJJJF7W86OQ3dlerK7Nl4kdKjTlo3kSC1TtYdtn?=
 =?us-ascii?Q?tE6odio5p+rktDt2aZdJOTPMvSxqQw8bx/8W1NQTI6bR4d5gyteCjZBZO6yc?=
 =?us-ascii?Q?DUVQhfB+phl0zZ0fYZJf8kNdDIs6/9LgrfidYzyHYeswc09NXYvoPFXQekBf?=
 =?us-ascii?Q?YAQdS/2PVeKa5K1W1jTyc8FHcseqfEYrvqQ2TMv3RSwYfvuwaAZXqHCpxhyX?=
 =?us-ascii?Q?WVv0QuFM+y9SICXwAB0vW8Z9BWQO0tIt2Lb0Vx2r/0Ydnn7WQxP+agM4e5r2?=
 =?us-ascii?Q?ZPTup6bKnIWVTvJWgnVkKDpXgJ8lXi4bvQHrj9elfSOkNjAjSwypM4A8SMyN?=
 =?us-ascii?Q?mCtoPMoffabto1iIsNQc+GHHRtdrp/4fefdh9K5SHPHy3crXMRPrLMw2txKE?=
 =?us-ascii?Q?jWxbzZEC3aEgSGLDRd1PfYwJ1nRjTDktMCxrmwPU2ZFHfB8Vu9xHRKLsX9Sz?=
 =?us-ascii?Q?3SurxCLM1fY/v2837VZ9yc6Y95vraqh3MLzJ2kQ14h6yNxBwWZ7FLfg5pjDt?=
 =?us-ascii?Q?J4+GyRJ2K7pzThc7hFvk482pXRMmUoU3uw57HCZOgTekqbfKnNMZBwddtbKR?=
 =?us-ascii?Q?8EzoSp1RXRSz7ZA2f6PEPfvApCt0BdfwIdQm3e1TE+g3uEbt05IlklkBugdA?=
 =?us-ascii?Q?yS/tDg41mb+Corc++ziKK3uPpewAPin8+WdgEjRj/5PIvkpXgVxvSkLM/9Ky?=
 =?us-ascii?Q?k9KlMy6uBpWFrl/Wu2YcBuPN5Psvt+XFPdWGRyDGqFyZsna16DimGHMBrMt9?=
 =?us-ascii?Q?HUPamdqsXz2XORK9GEnvWBh4FfJ1pmUvLdxsAYnEt4qosgWAx4qcgomkXqPs?=
 =?us-ascii?Q?YTn8JWM89LRqA1mtbJ96uYt0EsKYhWA/iaGcmYF2QH/boaRxHR+bb8pUvGyn?=
 =?us-ascii?Q?WJV/OCzHsAsevQN6YXpz+9OEa9cgNw5FPHt8aLahv0F5PcJnV6CGFlTe4n1D?=
 =?us-ascii?Q?DQClHEe+9TEgfVHQcYoPJ3gGbIbpj5Z78/xTJCZfT3kTyqLVzOKtKkD7w5XN?=
 =?us-ascii?Q?4k/jy0fPbxHVj3DGis8dWef0ONM3YK2mq/O/q7t8JsKGvRRKCBiGujZWG5Wc?=
 =?us-ascii?Q?S9IlLuqs+IgRPlP5zrz2zP8hEJnumACOarRnTblnRsdBF+2iQ05mePWGkarP?=
 =?us-ascii?Q?7Rbkkz3HYvbdUSfVsUcEuqxVjG0zUCk=3D?=
X-Exchange-RoutingPolicyChecked:
	gOdOEndaCE3Ob2t11uOskjxTDMKMgWahlmCFnJSRHK5sh2zJStDYvCqo7DUcbvb2mgDA1t1tNWZ2lb9EpCfQUlseokV+joWnpCDLTG4jheiAZdYNV48jV3D1WszNMlTF2GhIOMtXCCoxit/mzKTYj9mmLGKlrK0V9AKlDfp/CDH75iEhwTbQm9+rjtQqs2VhF2rsHlJyVEGGTs5Xp5QLe86z9d7J4czv0TZCL+r1XXOFBuxoH+tGYNvarmDGPgj3rMAadDXqg/+JeNQwEEJ0009drRpbhdIZFV0c8G4E5tWHda6q380H0KRCYJIzUdCl8Wn7bPrF3zYUTZBwo8XBTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FEB78kQA8inqEogaWayPQiQpaWUbmgX0RVqAoO5MGgQYyiBaRElSItwhLITuVfsmsOeEGp6m2WR5ZMDfNvuF90PlXEGUx4EnPlAg8Oi0xuYvE3lNmQfDnHRL3RjAkMHwu4R9AIRO6e6khFknFVHAc4X5LLS6H9rFc30XL3UYCRIp4VRcCmry/05fesupWA+bahTDF4jzdvJU6mNONEzdcb8+YMF7woVpfqfmCyvTzUPdq6FbNQsMS7TOKJ2+BtUJ3HWoBbSIAyfqHiMW4M+RM3AR/ZclknhqYD4VVnqIJG1nm/h3TsuZLnelxXaroY9SkREcrOo10IGguLURKrQKf2x7weEtLeTOWl5csesz1xfEETk0efRcE2rpZPw1sqMTCITSY8g46XwWveKXaq6DQ4XOeWSBJko+Cba8nhoa8NEqUruBkaGCR0tjoYgrrvSBc9DK8s2JTHFyr0qLZVqu4EskOlWoFZVZUIZ3yYgjyZBusNHgAxiIVsZoS7ng4l1wzAPTLRxrLclImbplLTsYP4l7EZGgRdhsgerwXrOqiYNSheLeQGwZprr1XFDkQ2fmXb8+IMWbuqbYMB+DK0ZvlOpor5urjn+JQ6IgI92PTIA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22505b9-aea5-42b7-fba1-08ded8938021
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 23:41:55.6228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHRE3Xlc/jBQGrc2pZhKsNCnRjqYM2djNeQLDTArOKMH9tP8oqPaY7FrYX069gFxz+MIn19P26uSpLzPmms1rHEX7AT+lQVFe2b7s7ezHQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=862 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607020246
X-Proofpoint-ORIG-GUID: PKCaY8q63hY7TFhs9QO-0MkTi5omGZZ5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDI0NyBTYWx0ZWRfXw4H8NcHkzmYq
 T5EVQXuss91w6RF0Qb6Mpj3LY6jKerAuQtPZjxFiwyVlMfONC5wWIENGDj7NWBwVVCDOjjGY91/
 gwO0Gwsbtor9LR2CU5fCf7nhcJJpl8HNY6hzeX8xrV7pPd+Ds9sMXYoNGNwHKhPwZTRivp58C+E
 g/bYlUKH2fR10t6GAc8MTn6z32eS5/7QhTeDA8AlZHHchbq1kUSDlzCStwXlhs2OypG/mTbwvAF
 77t9DXatjCxY0/gLhf41RRcmbsQv9YII2b7idIBGvq1Xyj3Ok+bBgQ+iXdEdXlmQ4s6IL9i7/xs
 zF6aOWRdB/2xoJzpxDrjaR8G8Pvr68IjMDQFSV1/rJfdZuGYtey78nBO3do6wLmOtkJot+RTRah
 Bgi1k+HhJdkeJoNdb2PfwghPGY19hUDMXF6IOw8zzXkcAnVPcTrKdkPOuaYYFqWDC9AkOWt0NGW
 3cgBprABO594jYbtgHPwLHEcJuxmbomzGC27aX7Q=
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a46f749 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=MaQmoaksjz7auIIbQzIA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-GUID: PKCaY8q63hY7TFhs9QO-0MkTi5omGZZ5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDI0NyBTYWx0ZWRfXwCM2oX8QWK8h
 6YwBcnRZ6CNNgl0TsHfaQ9Z70ZAPkSt3uVMGzxMvAF/iawS5iy5Wf0YqQYqsxW2CYBzp/X0I8V1
 PbuOLafJzrL+vVgnosH8UZe0eY8UFdTqeuTICPB4IMyHpsVcihhQ


Caleb,

> Martin, are you okay with this updated commit message? Would be nice
> to get this fix in so auto-integrity works correctly for zone appends
> on 4KB-integrity-interval devices.

I'm on vacation.

Will take a look when I'm back next week.

-- 
Martin K. Petersen
