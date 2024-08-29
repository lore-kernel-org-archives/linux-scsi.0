Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DD71171C;
	Thu, 29 Aug 2024 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724893210; cv=fail; b=HXt8KcUCU51g3QiIfr15E3fVmKm5hDMjRcJxNk8sfLAiWMzt6Z5YTQ9TE2ouTpRybq9u60SV9cPUMzs6v92sW6tbA3ejvK7yH8zWx+VgNEaGqsmPAeED6OZoDetIwAHYMrw6BI5GtfGpLULwSTxhiT3FWzpR/3joZal8Ko2JqaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724893210; c=relaxed/simple;
	bh=hhlGEIi5cY6XtK7nJm8nj5/fWFFxeY/5XJMHyTmMbL4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gp/7Eot6oVPrmfRwiZIcmAH7uDVQSs39XHNiiVIZoZmwCjuPW2xoC7DCYuAMLq4sD6haSdUAApVLYovYE7/nGQJNgmGp10jwg0vy5dEBrvDk++wzM6pIJLL8BKsLjXPnYvPmT9WJ0RBh5e7vEst69wbh/Q6HhUd9vQEjtiRxUVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KFx80PbS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IriQgS0+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KFx80PbS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IriQgS0+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47SKipdK003988;
	Thu, 29 Aug 2024 00:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=mA1ObtlvGfFNhk
	KtheKrHx4s+r2ML77r6x8hvDpuODI=; b=KFx80PbSPKkzKQe+emCUZd9HxQAU6H
	1P6t8Kc3NbHmghPlRgjeCFe5yETv2qHqdxY927aWySaFyISRhaN5wGvqBixf49He
	SGRF73q64sGjHJbndg1Lvg+qcCPaG1uRSABns3mYrWE6Z43ib0pdd4reF1PflRgb
	7hGXy1WzImZQOcDaPh8Nglp3RVGQEZJCXUTbKy/+GqGsYugUNHS2DPSht0suDDb2
	QJ4xIWWYuHBMela+D9bIm0KXaAYADwi4t+tRlVFgu0xjaB6OYiENrT/NINwquhly
	dMrqv1IffHH9CiGcZgQ8naaotqQ+kGFa0LYrq4FCR/xFMbNc3Oo1+HkA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pukjy7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 00:59:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNQ2Xm036511;
	Thu, 29 Aug 2024 00:59:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4189jmjrx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 00:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HhewSXkGh8ea/oIPS4tc/oVbUWPK6sOtgHZBPhNEs4BxmVK0+msAdG3oVFYq49O0jwUl7Pd0aH7xaeUZ0TzMCxRkM54sllL8twnju73SHegNzTvQvhKCiyteFZKJ6feoeT6w3oaChBvGEfFA6g+rbuyzQEvzYBpD+MnRKRzTlHy2iGSKPRW07vl9cSjjKVCUqqqFDOQeqbviyJblWqBavEXCVTLE43LKKh9GzbYLwHki5E7a9WcCuQpDVj45EfuRe+mnqcXVJBw3AmWcsTY04094YFyU0GSRYncHAej/IyBB8UHglILWCy1wl0b+5eAVOzrIvlxTv98BFgv5FORY7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mA1ObtlvGfFNhkKtheKrHx4s+r2ML77r6x8hvDpuODI=;
 b=PmwxYAs2R9bRbJhzlDIAuBA375yGz6SoQkL8k8wwjh4L2SIy4bmZLQ1bs5yq1WtJ6m8YYynYZe05mZv+MMcdlEJQQE1iUaCBqWVk+DHZ9YkrJV02xM5HbcR1gZAaMc+w5j44PBU2dXeHgThmQ3+OFE/uhR6wKmMAf0/jajA30N+e1smNuGMWN3PMPUzyDOaC8Rrk91i8a8xdqO07/jqfQtFp/Wka7AkLYgk4hcAgT/XwIGxdA+1XpPxfffuZsa5WoTJcWTCf0vNpVIPrEspZTyK8cUtJIPq+HpoAjuY3yaq+KvE2rvBMBe69NFzO1jOjeKhO+VhmGJ4mr7QcJAH1hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA1ObtlvGfFNhkKtheKrHx4s+r2ML77r6x8hvDpuODI=;
 b=IriQgS0+c3D8dAFkcNFxvQtLEeK3z3l5nSXjPhp7/qbUp8e6h5xlOMtpR0o6lCOvpTZl7ArDdILZV2xwXziz5NI1NG6qaJcLtyCw2J9yTzJMdLMA8NMgChaD+cXWUy5ueB7eV2bgtPdzL0jgVzi3lac082IM6s0RvCjYGnVwkaE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4698.namprd10.prod.outlook.com (2603:10b6:806:113::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.18; Thu, 29 Aug
 2024 00:59:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 00:59:53 +0000
To: Yue Haibing <yuehaibing@huawei.com>
Cc: <njavali@marvell.com>, <mrangankar@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: bnx2i: Remove unused declarations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240824084724.3647307-1-yuehaibing@huawei.com> (Yue Haibing's
	message of "Sat, 24 Aug 2024 16:47:24 +0800")
Organization: Oracle Corporation
Message-ID: <yq1plpsdtzd.fsf@ca-mkp.ca.oracle.com>
References: <20240824084724.3647307-1-yuehaibing@huawei.com>
Date: Wed, 28 Aug 2024 20:59:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0951.namprd03.prod.outlook.com
 (2603:10b6:408:108::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4698:EE_
X-MS-Office365-Filtering-Correlation-Id: 07bb6983-820b-4b4c-bcc3-08dcc7c5e487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FZDFAYxdp46U4yzDk+T1A7WZS6EuH9cZp/pmO6FR7GHf81k6g43YLDDcTVAt?=
 =?us-ascii?Q?E0jKO6FJyEQg/Pb+qeJHGDf61GX+WEEa63P+lSWB23F1D+frdm9irBIufMid?=
 =?us-ascii?Q?lWY1z697n3zh3Q92UAXUjeiCCsPR3tdUwmfoHvTFuA0psLqGCG0qpj6MlKmv?=
 =?us-ascii?Q?X2hn0WaN7Uy/IW5UnjZW0LbcIzvWrfDIDutPlPCEc9DnXzMSa97uLXtcdApB?=
 =?us-ascii?Q?X5z8aFhfYBD6VWSw7zJp2fOhnMOsxzPgfbVLuDRFrMsa0AhfKMdkbVVZXNJy?=
 =?us-ascii?Q?S7xsazpt1BLzBBol4l5nH2myeR23nCLVi9mH007jcz4dVZ9nu0ho8nSYmPxa?=
 =?us-ascii?Q?iQQgFrgGRiL33L0PjCY8qeGIrb/SYUaiNY6lS+PTZ9pXnafrlKc6wHE64GXa?=
 =?us-ascii?Q?f+yxEuwMrW4BdCdR9tHTpDln2WnZqYNjxImqs96JuHwtBlokhgiGhYpuBMEM?=
 =?us-ascii?Q?OmhDJZ/EXp7W97QMrkisaNraoAwIxhFL54GAjgKjaMC19EW4BAUqYqPAZ0hr?=
 =?us-ascii?Q?cV4iLRVJPiWq4qE2iH80BGPUxJIxhaIQrNYW4eyNE+xNxcsSvy8VbWRqNKG5?=
 =?us-ascii?Q?1TJkj0SGvGlf/zs+P+C23OWwGCL6DyR+7V+afMPTzXK751HwcbDOE/V7Ap6E?=
 =?us-ascii?Q?gkZ5E8kzQWINy2Bl6z9/NHh936K+L4+oaZl2+qI1Fz9iQaVJPh2ZRrRAB4x2?=
 =?us-ascii?Q?mpDGPwpaHkeCKnG6Sa8wJeO2CZYALijdtEBlyVXBZYkmTvcnqORFJ9u+l82O?=
 =?us-ascii?Q?cqLa+KSRAEeTw5vrGgEsGnbOJ+bUMEKQVCENfm0XbFjvimv52JBGr/+4H02X?=
 =?us-ascii?Q?Pfxg+QEOs7m/1npMtUsgNqFA9jV0lod2ZWLl6gxHotdlrt7iKCEG1UMTTk3Z?=
 =?us-ascii?Q?qaZZGUR8ne9AoHkJGk/24pQPrsTCu66kY8+6ZVcLkB7bUOeOgrhV0hDT3O/B?=
 =?us-ascii?Q?yY7bxZMk2N80VKRmxOc2UQaZnRtJk04sMBc1iKf7Hyblj7VGpWf6lZJ8zmE/?=
 =?us-ascii?Q?tgN9jnMuVS2m5EIS+ecVEOZNxzsDKxBEZiH21Zp78678aoJj3rVwwsUz3RWo?=
 =?us-ascii?Q?4WJ6iNNYBIn3H5xqUHddGafrV/wX9cQi3z/DmJacQ7Lw28SnhxBEYQfhPg+e?=
 =?us-ascii?Q?9iIY431ZE1Y8gduJwgtu0TsWjAhqB6cshteEjL2qWvqX72G0GblVeqfH0Gqw?=
 =?us-ascii?Q?OMgrTtFZGkhZwqMLlKeHpFDkMbAbSPRHpqjxnmClgjpuAnYS+D5lmkXZFK4c?=
 =?us-ascii?Q?jLWeNhtdCi2UO4QVhRw3OrwIhFclkjHBMssiJL2jifaadqfvBOOeYGyJ7B54?=
 =?us-ascii?Q?8s19ZCJ0yh8LJDJjYUjTxbI+vRn62wU3HFrT44R9SKkxow=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8SXC9cDedflGy5KKFpp/96Lug89IyPdzu/O6KyxQywI1TE11mm2UDnqSMxKf?=
 =?us-ascii?Q?HWj2RGeVoSX0opHh3c2JVd7f4cJ6VxTcKBC8xrUY11DzsMzx0A6wSllV0IUp?=
 =?us-ascii?Q?qUkRi/OUQUtH4fXrmHqBd+6cnX8j03mf9QBYUmvTOlsahaXMiqGcbbdhM855?=
 =?us-ascii?Q?YgPVvAwz/StW/rAJDkium6Y1ARDhsXKcqv9pBixalL6rIzeFzHECijx/eaLK?=
 =?us-ascii?Q?2rtINvkPcm9OXDUlCM1/bYKdvz079c0hiE/dOLsuECRFNqPaqjWp0o0zfsrl?=
 =?us-ascii?Q?w4unG4RexSXh01fGR4IU48TRbKLu2iay8JglcSgVzl0WTaiuw8hgODe9A80x?=
 =?us-ascii?Q?CrDHravUgVWAH0bLBH/+qA4VaOWnM7bzJafXARmOwepxmaIfj03azVVwUya+?=
 =?us-ascii?Q?wLWBZi7+1MHn/rQfsJgD2s2ojKWO3fRXiWmUVNdB74DP0YJCVyb3JFl6t9hL?=
 =?us-ascii?Q?lAfxoCtXz1eEgiNaSL/EbgaAqRyQYK+KBelIiPr132SMDPmVm13NZ+4QrUqq?=
 =?us-ascii?Q?uC6RcSv4QLZH5mGOtPrpj2wdXfJTMUMDhRTbwMLc01BwxkP29Clz5kDObBX2?=
 =?us-ascii?Q?tx8lvDmDeIruIoima1aUZCIV6CBxLCmABC6r5bjx4/oq6WWl45eLGSYwQJ9h?=
 =?us-ascii?Q?1YtBd4v0+7XgoSbbxf2BU0xks3Cbx5OcsCPIx3MmejfL4X4wGMzOY68ueCYg?=
 =?us-ascii?Q?Np97qwSzHNG1DhOER0I5G4I7apnK9iISf4xTlsHwTkraaX2VTsCscEAkanLt?=
 =?us-ascii?Q?UMHvMeFTPPXrVWw67s69qthQPUmNdOtlVkGd80qebPSaTCkzTXP7TnxUWk2G?=
 =?us-ascii?Q?I5oEK+VvdxYA0wLaetinzJVycD1lH+FoJB0ue1tEBY0JESnQnkC057KbBH55?=
 =?us-ascii?Q?v6+ibo9yHhGFbreW2kRIGa4QbsbgEo/g6ZUuDNdtKnmCigOw7K8jL86W91s8?=
 =?us-ascii?Q?i0ARxaHPQ2BzirSDckfF7Jd0gJA2jI9hPciv0p50Ceeo1vqBU2xxZAwkff3l?=
 =?us-ascii?Q?mdvWAXYdZjClS2Z6YBemXE+aPd1tQSOvnezYAu1mksFytiJ90Rb4psuxEE3t?=
 =?us-ascii?Q?kJTq8pFDC2hWE8Kfg2ezkCBUp6uxryTuFYoDV9PpBOxi2trm9Qtmj0mIICRU?=
 =?us-ascii?Q?89l4bbEdv7fe6NYxRqsVk2/LXe324FLnirmyKqDDdKmXfUIoi0VSoeRoa58N?=
 =?us-ascii?Q?AlTuT/unj2wRKhlrGUVvHahhnfmSOPQaAtA22qqJLO2aa1ui4Vc5a35bDYSx?=
 =?us-ascii?Q?lgMj0NZLDgOmQrcChkfQmS3xE8WENzx8MlpjVdVUfV9OQlYmnLokuunuoGAT?=
 =?us-ascii?Q?7fD32rr+nh1xSx0D2pEEkR4YMdMTQ4jKBmbePyIOwIvBKiBjzLOsKyLeEMxr?=
 =?us-ascii?Q?hrllpQCilhSKT0IbYqFFKp/JW7GmtXglUbddfJSHg/XRG5dqZmmbMJR1UbA0?=
 =?us-ascii?Q?bEfQpl+oMFPPeRvAu/XK9edakAf5AV0RwLOeSd6btroos0+K4WeBqPUYM6ag?=
 =?us-ascii?Q?BTSmyQSuiCSE2u8O8XM4qmRS1sSjMORcN0mJ7Fk/6vW/AQWLu8cp2os/Mrr2?=
 =?us-ascii?Q?e1Zwwu8RgoIXOHxrzToMfR9BjgQ77RUdcuysdefb6zdLe9bqDn65dNIsiZt9?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X40Yl7p2bmVrDwLSnG9ifmMevHSlQLO2X26Cy8iAeKKmvR1uoiQVfEaXXpp0aFq839WxSYa7G/82hvsaFXC/nY6l44odv5Yp0dzf83CVzzuW3zTvtBFsqfLFFK3x1fyD+2dBr7Dhv1n8Jyof/VRLcxybrBajWlzxr5AzX9tVwQ8rYb1oxB7COA59LCZXAhLi5FX2xrpOWV4Z6WwAlBw523JZvioDilIfVQuxSeN0kz0dEpSctTo14AE4fxAoGWSgJ35Yi9iMFwBK6I4rVenDNjlkh/HBEpEBD+YdyfGYTTIhAC/JvkHtsu9QqIDMCCUulysrLHrKcOnyWDjYDwpfcG2yk5+UYz57Qa1Su1gZXu7yf28AhS5sdmJqivo8ZrZ6ENxwfdZLV2LV2u3lL6EdqBoGz1QhCbM4kts5ImcHRoUSTfQZ25dn/l04P+OrGduSo7jVEPkq0qOta2t/pYV5eg8sp7VOuPLsF04t6X6jo/jU/a0qlNZcqC51qQmuHZrjeIlUxbDj04upDN9TL3EYp+78gsC3zgz5/6fhXUkpdmeY6s6mTwOqOufFk+u2M1bVp0GsklqRx79FyFWhwt+hHX39pmiYUvHhyCLvAFCvblU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bb6983-820b-4b4c-bcc3-08dcc7c5e487
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 00:59:53.7206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzdpMN8DRKEbt+C6YwWug8TcL1OvXhvMojh0BS1dAfvDWHJQ/6OXVw0vp96wq6ubkIVij3y5Vx1r5iG+GxTbzxHVyBmOR4FyZLrX/A3nj2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_10,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=778 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290006
X-Proofpoint-GUID: o-7np9v7m95wr7sJJc46vYhE1sT98kjY
X-Proofpoint-ORIG-GUID: o-7np9v7m95wr7sJJc46vYhE1sT98kjY


Yue,

> Commit cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.") declared
> but never implemented these.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
