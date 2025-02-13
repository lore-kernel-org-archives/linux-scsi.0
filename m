Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EA1E48A;
	Thu, 13 Feb 2025 03:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415729; cv=fail; b=KdA80UidROERUddxZZM9LIN5J7D+0C+WANOoNLl+LQHWLXLltOczPStV8JyiWLtOogvdQjyMSxxOFzV73SmnqrbyIOEKUrVGriB0LaSB6GuB5LGwh5GQnK02zE5tEzFxsG24fwP/MIW12NYNtPPb97xOs6c+fV9OI+Z0sYExNWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415729; c=relaxed/simple;
	bh=5iZPcXzLouaX4NHMznZwLxGDYO7OngEGyp+cYlc/Qfk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MKbSW2w1N+On7kAailOYprLgn+czqrMfgg11vJiQt8rqfAwJJ7ttr5pL+SHIzld/v6JGJcfPQuevV9s9u5Y+kHw5/MJ1DcK88uiWY+Z2y4xCSD9Xs1dz+6Fr36sQT//WQyNm4PM+cCu5QwTFj2edLpa6E+Nt/cde4A05ln4Q0XI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dRzN1+O+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Th+3xM4K; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dRzN1+O+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Th+3xM4K"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1pc4D012371;
	Thu, 13 Feb 2025 03:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=PsURIeNmGvzNsZBIyU
	ZaIyNyNCRwQVlpVuy5DOBDP3w=; b=dRzN1+O+RKDwAYeiuF5MR6bmg1KBgLu7Vf
	kSl4yRntd0BvTu7YK2fOlXA3OTqvqfeSQjoCpnwygjbLu888ExaOJEWvjY/xrh7w
	aF++e/SA/ASMVWZvLCN817pqJi20FQoc5YJ3Txa5hgCl5HmAfJ7FZSKom3d+oyPG
	VtUpxvinxXx91ksBa5p94WaL2ujo0JHYHVjm4NVAjOedtWC/O54KGN+SfVTUX0Oo
	vzJwlnhFTmDSinIiVTVWVsncRciC8belCuilGSA9w+EMMnvendZvOaLqyGJpY1XJ
	vCuwxTaPNtE0aj/tujAbx1QMAIqAyELNKuF3xtH/7Z8VLUXDEwKQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qagpt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:02:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51CNrZuE012509;
	Thu, 13 Feb 2025 03:02:02 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb4anw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:02:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPJpb/iPh64au3dVxAhw/WpJ61i7r/gbBwuL0J4TsOyjgjXgKfEAn90aZeU54OLUHQY/lK+MHjTogY9CAVDu2Lww6aDRF4ZslA+QRmqagd3nVkercsusDqBhmrOVi0FGMwSQj2aQ/iD3SSMRrtjyTuqxImM94tmO5i75fAekjBfwhzlys7f5dwDtJDYqA6gvQU/FF4YnI/YXDYIO7uWhbKTOYX+/YITaeY1p5BggwwGdMFXA6Wm1dMy968JmaNUBRn1/AUdsZ300jI+hmhgEQmfl/kelDbtqenXC3QFuTPhQ12XR96VuAxbjmAUYWv9Vw8EsFvD8e7aaiWG/Jeb9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsURIeNmGvzNsZBIyUZaIyNyNCRwQVlpVuy5DOBDP3w=;
 b=cTvMVglGrTnxiPydHVNA/BtjvdldH47qVZyMYRmC59qYZiWx3lo6VaaXEodbra/0LKMK/z2hiGlfOX/KZ+QPUGOj6Wq68Pa26owFbsyoocO9q/zQeQDm8LIwgE/npiKPa2PQ5o9tAtlr8IxMxcgJj1UqQoVKvKi6eVZan/FUQ3mT8TjZfZLWHBrrZsIh83Y5nQPAYFjamUzhT9AXoYYDwKlTmoSiY+hp0E2wDYcJ2hr3Y7N+6bqkaGhYVJyDG0Dydzul2MORJlIdrw35M9/e72ekNRq6a7ktiCoq2YW+pyCdlwjo2YTvQImML452xRCRPiQ02e645A8dcGKgGfEiLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsURIeNmGvzNsZBIyUZaIyNyNCRwQVlpVuy5DOBDP3w=;
 b=Th+3xM4K0VaJ+BpY/pb/5qlCayD4yGP5zlFPgefmLTCLUB2bsup1yY4Qj/2OFFWMxlB6obyvHusFl8QlZplvvO0qXfbEC6JZVEoUSyyhGgPpzDg1FSDw3eCfDDSQWvh284C+BuOxcWjMUsRwg97rZCo8RrPesuBWmd1O4FR/s/o=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4940.namprd10.prod.outlook.com (2603:10b6:610:c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 03:01:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:01:59 +0000
To: Andrew Kreimer <algonell@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Eric Biggers
 <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Fix typos
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250206084905.11327-1-algonell@gmail.com> (Andrew Kreimer's
	message of "Thu, 6 Feb 2025 10:47:03 +0200")
Organization: Oracle Corporation
Message-ID: <yq15xlewns3.fsf@ca-mkp.ca.oracle.com>
References: <20250206084905.11327-1-algonell@gmail.com>
Date: Wed, 12 Feb 2025 22:01:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:208:237::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4940:EE_
X-MS-Office365-Filtering-Correlation-Id: e291ef11-3f0a-47fd-59dd-08dd4bdac87c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IhRG2zzMz9mpoYcm+FEnirSM9TExWFpA2LwmLecGeRKMLmQbns3h9+Mur+D5?=
 =?us-ascii?Q?MYyDBRo514RwjmsdR5Apl/YzuFprWUMwSIA4VFRyl/Pc/Aou+YALkCU5lWPw?=
 =?us-ascii?Q?X0Dr8ZBR9ocPq4cw5EdYj6IyjO3snJKTiUFMsLsCUpFNwZ+jUYcVx4IUnrn9?=
 =?us-ascii?Q?lKV2ofe0SZ8vlYBzVFutJ30qII1JHo6/TCHJt6YarvmTob6aXkf9D+m0VvKe?=
 =?us-ascii?Q?8fWCRoIJ7LQYcmmLbeIKwgoRM7qWU/QzE/kmKmwTK6ROgXZan0ooyHiF5mCu?=
 =?us-ascii?Q?WGfIlwMFVwmnNnVJgH3dZvK6EmQt6v/gYD89SRKamXQwx+7ZeOfPzlYcGRVY?=
 =?us-ascii?Q?wHMoKrUnBipfHLLeND8I6IXrRHHPVAxMveVwbF3lzp+d4c54Fsrpma7xy8zh?=
 =?us-ascii?Q?YzuxwJwjsNXDo0QEDo6rVWQnA8H9m6H6VuonJOPcsEm2j5c8Emp1f5ivgn7A?=
 =?us-ascii?Q?OTOi5g+nmIR4EQ4wx2xMoves+Iv4MkYgqJ5W1Wp1oYoGFVW3oH1SiLkY+SvA?=
 =?us-ascii?Q?GKhaIBX5qrD57GFiuO3r5Dl5H5w75l6ctICcnxE+pkW6b4orV7H8gr/WScWr?=
 =?us-ascii?Q?Ac8wLuMw/cdY2JLwy71Fs9ONryCaNPoUBnvv3XW1PUi9JLxbBCwxoZvB7Tn0?=
 =?us-ascii?Q?Gss58tEJa9JY4+fGLxqmK/D6mUHWC/nsNHh32LODr3OGjeLMukTRdqGSSAl3?=
 =?us-ascii?Q?p9etnfpOThr0y+gCrsvOFSF/BcMtvyJ5rWosoEgwJtQ+x+DcE8XngH44Vhtf?=
 =?us-ascii?Q?3g8SRYFSiy0qIaHNn/Tudnw+82FaPLruD/ddr/Uwn25bsBpAhcsP7V3D3niO?=
 =?us-ascii?Q?Ai/FmQDUU/BP2uWGtb2kPgQYsx//jQSA8IFqL7+Sv/gWCCtnh8b7eziXuo8a?=
 =?us-ascii?Q?skI5coRVQhsFiT50JyBETltZBE3lB6/qoMv1ODILq1vlhyuOESOaZ7cmBd/K?=
 =?us-ascii?Q?N/+twS2Nq/QtmdTObj/wne0uyEUSS9yfoX7YyiPuUP25oywcU23nBL6YkCFA?=
 =?us-ascii?Q?hOE2Fq81vg46pJnj4OC7jbYC4p69k308AlSbxbq0yiGUyE0b+4nhQa6zfvk5?=
 =?us-ascii?Q?O93JNxfnZROhQrRXic3M/Xe1XChvMvcg2Yl5X2+esrXYidqj08VMc1mMCyiR?=
 =?us-ascii?Q?AwSqe9PSlJ6BcCWFJRquxJ4nvkjARhNfu7OXyRKvbP7AHXizMtU7QiGpbtK9?=
 =?us-ascii?Q?pUXIT+QeNMGnH7XIK01ajNotFdWkoG8R8BvGRgDqss4ZnX0UpnXhyhFoEF7n?=
 =?us-ascii?Q?YDHr0GlqZrMtjglWYhvoYa9K2+eSHQqxVR6nx1NGOe3JfIZ1v8VOCVFZaH5J?=
 =?us-ascii?Q?6HnpxF64qb6sOmoGDG+7M+w/+6U4+dDUd3xpMUQ3Y6+VgD3x+8HLIVlr2r4I?=
 =?us-ascii?Q?kuWll32i9MI1KNUcAje4+/fqmgLn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bvC0hqja2qSbq5Mue/MWVHtn5PzZITJavSZEUXROm/qU3H9xPL6awYsavCSy?=
 =?us-ascii?Q?QQTvp1NbAr5HyGWKKpfF0mNl2EJG5jXeoNd6C6FaOhLtTw/IpsLMCYdJzZqi?=
 =?us-ascii?Q?+DMchyFJZ09fmeIqVlWoUAvCLvZPmT9NAYzutpxaxqwAs/5eiRLYXaPKlFY3?=
 =?us-ascii?Q?7aXVht2Sdlwa1VBI50KpjIVryooj4laCjWtM8LU/dEt66Aqiey/n5WMYV9xP?=
 =?us-ascii?Q?ZKVdlkXzs1qHruAn8gHFkPKO+9FTzkXm5DeXDbvHPeIT6amNYpQP/l2VoUKw?=
 =?us-ascii?Q?ugqC3EsdmAZogtsQJQgG0ZMZQC/kRkHO/ItxCl8vfWBHN4XDH+3Oz+6bmrP3?=
 =?us-ascii?Q?sZ/9efWGsQ3ho/Ni4hjltC2WGZ9qfXisaQ8tvtHdd5+GYmkmGL7Agb+HeW8T?=
 =?us-ascii?Q?w9AHBOMgHC97M5kqQo2JPyoMLqEjOuKF6zyzTgfOKEcNyoTuuvZnwAgvQZck?=
 =?us-ascii?Q?jqToP8SbCQV7GbY0B+e4UQdI/FzCR+FoNvvF31KIELFgUCYhC+okCjoayxjh?=
 =?us-ascii?Q?vr3wKYrCjzRE3593hiXKrke3FsQ0sJQhfByV/o4Xe/XAcHEEw37lZaVl+CX0?=
 =?us-ascii?Q?VmImtVJqqMc//yPxnpK0lp3y4iaHF58KTmJg49i10d0CHwYs+wG0jfV6reDD?=
 =?us-ascii?Q?TiP9YeG/Ol3f+ls2Gs3EnhUlc/iZOS6Vs54ILIOvgIPJ2g6YfvDkXPqir2WW?=
 =?us-ascii?Q?HotIVb4dMBw7ZERIoZDq6jUsK0Ez2zRIBqvwMJmtu4MK+6eaG1CF928Caae9?=
 =?us-ascii?Q?cJN7GFRRN6EopB1fxF3jp14vuOxELOksCFbk5KocwoZn+NxjJmZiMLBWtLWV?=
 =?us-ascii?Q?ldMFl9H+JcXh3zd7IzGb6vzJkJbBOBknmbHsgFwk/EOGsmEN93gicppFdyd6?=
 =?us-ascii?Q?pJ8VgTlAidEDEtDslwndBGiyAeNtxeL1eVNbbVoQQrKBlT9hJPpTP/XiU6jA?=
 =?us-ascii?Q?PFO3FpmFJ26W97XdNil2tZNc83VNP7SaqzaPVA4831Vgf6mDIk4V62gGxprq?=
 =?us-ascii?Q?0uk7xFr9A3oorJ4H9BsDQFoIkEMV614pIX5xuWDrKOC2RRBYBdHBCbMMcPhe?=
 =?us-ascii?Q?EfjlB7vUgN3rD0ZpZVUyuEatDk2Be43W0EErS2yK2O22oXABFK7mtS1R+lSU?=
 =?us-ascii?Q?Upcb316mY5NWs0fQ4fJrNXVfjdMWLua9cPnpxXESgeYVNn8RYb4PeB0kTXsJ?=
 =?us-ascii?Q?8DIqwwY97ZHLIyqw+KfU09SO4Nje0X+wf9JALiMkPcpXK+mjWGkfRNZ+Ukfr?=
 =?us-ascii?Q?Mg/NnhT160gPIqLyz4eQRxTizHAqNzEsJTgzGAd3vzJJ4W/3d6QuHT7dYIKv?=
 =?us-ascii?Q?inHN2zLqWOs3Juxfjrl9ys1EQZjJGqF+64Xh1CeQWq1KMfY7MIRt2iNkZMyk?=
 =?us-ascii?Q?WgFwdwXlbaA6ZAN96JjqqXshTdC1Jlj+VbLbUujQLfZ02DKdAfoBS9RRuy2V?=
 =?us-ascii?Q?bhQ+Zn/oNcjfJrTYH4ySl5UpXdNdLS0J7D0+8GPf5oCsuV+iBjQh+d5ivA+V?=
 =?us-ascii?Q?6bflpt1VWDXWZ9UJCGaE1PoHgSu/NcHrAw1chgA6XK8GnwJXlPjHMhKGxqWM?=
 =?us-ascii?Q?o8MZXqT8DZSlPFAwAoHsMpeA+YDjQKz6yO8x1jB8cnncDu1B9k0Hq7k7Jlz5?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vkMRDHAIyc60Qc3FzbDjP4gc9iYuTca8Wj7Q7sX5w1U8VHRqXX6jekOfufcA8IjzxqnHPCMTgt+7qy043iMfHMC4F32uCOuKpRKIpbnt9v4mKFANP1O1in1gXNx82h9Mee8brPAeRZiXbCKLyp9T6mopXhMMJltvIcn4CcKyJliqDXsgxP2YdQSSDmqPe9OUm8u/nDTfIZ8nLZDa9PbVxmPXnRLCPBG92qEXaexZV59rgj4EqaFMCinNuHz4uWuiNVgDtMcsl0T5MPD/Az0gAhHIYODVSq0qubwZd6OBxOVSPvtteLDZKSCLdlSyNSCeFDZv9wJ5IZKurVVN5+W7hq76K0LQNU5OnMa6px9r4wK6iIy3lYhpIjO4++cY9LbZAWMRLz554gMhW+2ZXw4P7ODgkThE3ykRrrDPXlOW8Oo3rSD/bmC6Uxe5S6p1ZsvFhhQvKPikWyt+arps6j83uaXxDgrj5C83VYrGHF4xQyPnff8Hgk8Lo0usvzq3c88v21AtBPitX36FXZUL/m0PJc+NyJl1HbgTGWJnO9WlOYPZcudK61GE6PPNXZyzCxsAqMfsESkMDmkl2vBREckTcLn0mr/iSb21+n1yrSa3iZs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e291ef11-3f0a-47fd-59dd-08dd4bdac87c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:01:59.6347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIZbnybhVtqwK5MlZzujTU0l36aRyrU+oTthOGA/XaceeNwO1taIvv8BN8zkdHJtCa8f/leyIxyEZLqRcxQnHHiyPDdeAYVx2bvsa99jwXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=804 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130022
X-Proofpoint-GUID: FA8mPX1AjMl2hyWh3l_XoUm-fN6fDeF-
X-Proofpoint-ORIG-GUID: FA8mPX1AjMl2hyWh3l_XoUm-fN6fDeF-


Andrew,

> There are some typos in comments/messages:
>  - Nin -> Min
>  - occuring -> occurring
>
> Fix them via codespell.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
