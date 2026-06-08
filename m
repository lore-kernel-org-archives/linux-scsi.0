Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3430B3AB27F;
	Mon,  8 Jun 2026 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954977; cv=fail; b=j1A9LRzspDTKYPiCpew6It67MryHBJIlVJuDwrKchgB24BPQcPlOuDQqZu6ws+brosXzWtEUFSswZQtALunItCFD9R2YzegYDPSRQbuf3XdM2xYFaEtROAKRdlh/YfcmO9jovQ7w8iRf+ZoOVOBaMK8PoA0QW5UDtxBaLoHQ4b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954977; c=relaxed/simple;
	bh=RNHngBseiBr65q8MPgqEXx4vZS1zItNNSMG+OfK+PN8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uLR4xh5mZ/XO0/PPBRfCQ1AAzDyMYkOu1ZcEVoJvQlJBhLZFBBAcsNa/5AlCQsowx5nN9S5ms8yAGgt61qhzPKaVpQcSwQuHGgWsH+dN3DHLV6lqGdReF2hx8gElgLTeR5YHtAVKG5I8GgUG6Mm0FNu8VgAJK/VR39sQpYbkfi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oOcXCAg/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T8pV0rCh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oOcXCAg/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T8pV0rCh"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSXOC3977362;
	Mon, 8 Jun 2026 21:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BHRLMlM/qBc2XRx/xV
	lAnnG1PoaRspljchGLs3JmXBE=; b=oOcXCAg/pEyGLesK1XiE3QRwNiooCKE2ur
	YxfS7PrJiWXCYQ0XQGKhC4x40jGHOPCiCzUdVR7+62+Cn78w5X5WZsjiO3AW7k8b
	F9hb+tHN3WKBqLu2yIl+WYpr87X2dhsJDSDWcTKtZv1HTfMDMc//pDfDCwhVyjeP
	dVHUJOIhgnC8WaHE7TGQAPQSpFeH0dF0zlZ7WSWlQMasPNWu3L/X9bafVoh0Agy3
	mmn44a+Y5gu6yNrdRj7P/y9u2fX/1MPdUTck5RcKNaPpMrs1zywjP/eIkj6O4bYt
	D424mrrn/adwgzFv9b6VJdWaEQL7tIsU1vZQfDo54H9+F/OMOpQg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embkjba65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:42:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658LbugM013554;
	Mon, 8 Jun 2026 21:42:23 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013055.outbound.protection.outlook.com [40.107.201.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0e2kju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:42:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIGxLwtnzKIBghFwxIxsa9YH76cyNIEBrDSIA+Wg2xHGxmGFezloCaC6sRacoxYO4CAP2+BiPpZKI3f7UdGtOc/PWnN9iKgIYaZj+wAOmvESozLMzYk+Qq7uK0NNCnw1XCRL/w72GJrPUb01mKjEmXJUVBtuL/SdW1u8cwAaPjLiTCkARIPdijx4NRaFmUxLV9z5oeJt/8ZaIUm0gS/ihqS0mx5YahehHuivX+GJfdKRbmfJWEYGZUypZ0HejY5roN4E88inFsNK7FgQaNQjwb91Ytp9ndib2AiTUgUkCBmaNLqmewcRHX9HBZsyOnOEd9OzbM8roU/ZxnYS93FP0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHRLMlM/qBc2XRx/xVlAnnG1PoaRspljchGLs3JmXBE=;
 b=G3CP/ULJtVqJ3VKO4eSewCqT3MgQ0766FxcCEbuwfHN9bHgx5wRvFWZu0v/BBVaxMJvPxbUHqXBzGcFMWEBlcQG1lz6Xh3K5VPlVGAQDMsYuoxlHAeu4M3VmRYVeR32bbfn8yQmBe7xRZQzA0EyJ6n3EcKfGF9HmA2X26kk21j0QYLvxjD5CphibjD0ersVhldKcCXX/DA0VHkM+iy0cDdEAxvB7eoyY5Bg9NxsHqQMFsnaZvUdZhkVI16oYXbHYHCRfPDBe8g1KSmfcwjuruw+P4YPuWsnBePUpGOxmI6DXwYvWhIJOR8zfvE8JDnN+1AndSCUetKEW9W9wkCMTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHRLMlM/qBc2XRx/xVlAnnG1PoaRspljchGLs3JmXBE=;
 b=T8pV0rChrLMD4Mk4Y3ikTP4+c8/CzKczT02UqFNhXkPwKer/UlMuB6b7tNFFWm98okdKwdZi06nBURfzkH42C1rDiY+fj5d9EeDXYYJynQm8nFWZD1jJKxDxWR+YmYm4OTtNaT0bW2fQS95jPPSJFq+O9a7PfXRZNhpE2cRCUKk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8537.namprd10.prod.outlook.com (2603:10b6:208:583::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.10; Mon, 8 Jun 2026
 21:42:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 21:42:20 +0000
To: Hongjie Fang <hongjiefang@asrmicro.com>
Cc: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <peter.wang@mediatek.com>, <beanhuo@micron.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260605112034.3802540-1-hongjiefang@asrmicro.com> (Hongjie
	Fang's message of "Fri, 5 Jun 2026 19:20:34 +0800")
Organization: Oracle
Message-ID: <yq1ecig4slq.fsf@ca-mkp.ca.oracle.com>
References: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
Date: Mon, 08 Jun 2026 17:42:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0446.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: 321c8268-ea71-499c-4647-08dec5a6d12f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1Bb1ETpFF8Qhvwxz2fuZTnXRmqLrbFgbiC5zqPrP6Qh0HBM1CFZQf3AkTe843RjmqsTIjGAUAfFzGDhdDcJjTPNumbXQL5HquPibIKpqz9QAZwS5EcFx6uIqRzNF4eA+dDVIG+OnBaippJezO4xYqca6j0hemZJgI7liaoQlrWwIYkDRlsVBGkuueEy7xefayE+CaVj/IOaownsyLnemCMqngxwhEuwbuOX2RtezngtxfiF2lS5VReLhbb2xrUuhT5GBnKco1upyJdf5Kn18u1JlYiDzqYYWw1e1Q7hK5sYl1JFQq6/Zq0L1Zq9vP3EjY/OXnEwqRwNIR8ziRrHTxoDkPHHgh/w6SRkktAjYKVcfFVsob9nhIt9BzNxBTGgG3P4R+6is2hwJTLgfyjjhhC5Vac5KPhhsN0dNSrUK7hbsT8AoqQiajqG9qNes382DgEaf92j2cs0L1vVRHfZuW2eT7hoQ735wsboGdfgyUF9Hw8P0gleIzF841qWPicaUAkZegwBS732wrHya2SwtL9eugry580GkoJ5KBvaEEIDJ//sr4iuDIxpj5Wd448h8HYhOKp3ZrsyJ1GbLcRCXuS1oW1vsYLp2Q8f00dQ8npJnG1yfbkTJ+92ChuO+hXnKMCk2gOCV+bIGGC+W+9KkY2HUhVpM/KBkULyo2UPB+lqAPKsM4OwPh5FfclDK9CXa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OeHE8f5/RukZUL3SohK4mu35Jf5SIJpSkMjhFcQzaFGf99//rsC7lXLRybLW?=
 =?us-ascii?Q?ikK/LtKyLpFkPdvUQqlZYKPPei5HRfSXGamQcDAUqb8q4raYCzv0b7El3T/h?=
 =?us-ascii?Q?F8XNhnyCzAjn/tZjx1ZcVGlNztMkLihDsjerIvwrhlrGtQjididjdkozcj7n?=
 =?us-ascii?Q?xdBh2MC5MLqxiUI6XqIeKoYMdZweRqF5KMQN/PYiOdXnS4fNfaooarFroWDO?=
 =?us-ascii?Q?ph49DwpMH15Bb16WtzWKYwcOoZeeEPKHfxNkmdCKXZSDYl7iMLtiHe/WtYEA?=
 =?us-ascii?Q?2Hk27WaB53ZAJibW8H+a56SaFeBtB4pmWhBQQvLuF3aH50lfBmbU7R36+fma?=
 =?us-ascii?Q?VY4mrpY6BCeav6k3Ner5LDa9XXEAY38q6hSPdxEfCjTYv8+Yqc9bIqdG9mWE?=
 =?us-ascii?Q?3oqEtui7oAPLotxudNQltCRQgD1+fb/F8eEZ/9CnX6I/JBztPltRX5SMvjFQ?=
 =?us-ascii?Q?D0x2TGdNXN/SazZeZ/i6M46S49iffInaO6VMHVbMDWLHB3Nvx5JYjlkYFuex?=
 =?us-ascii?Q?8IrByxf7UTHzR7qu/3tzPGRJ48ebHDxiCUxu4zUsUOFWXPGkn/OpMPvN42Mn?=
 =?us-ascii?Q?xcQKWdVqwWWji1DCD6r5JYXaBPZdByODLZvl5nI2qVkRb1RvLLScNBH1WksZ?=
 =?us-ascii?Q?Cd1qSxochOmlvpk0XBaszfo8oMDJ4AVhXA1u6jVXupKUBRpRkMIRJyW5vRhI?=
 =?us-ascii?Q?g4DbqUYbhh/cBUz0V96+3VV0J31VlCOJ1FJRl7botZNuyfBxlCQJV+SNe2Bp?=
 =?us-ascii?Q?Y1zyZBc33MKnfXvSrRO7LO+h7JMrJELm+zFsflO61BZVWnWZJ5u6FVSlUYMq?=
 =?us-ascii?Q?3PbOjEUbh8F17tIku9oZ3DzuvzmFbNYq3xWkCQ2XrohTQWW1HEoW+lzWKsla?=
 =?us-ascii?Q?K9NT+EeaHuO2WpYw0AAAk7Bsv3+ZoOUeBe2FmlzObcP+V/LtNEtwG2K/IU2B?=
 =?us-ascii?Q?wl/OIBJkZaHdMzD2dmnvG9t4+mRWcRq7BP4Bl0sCBMaq+lxNy4Q0g2Hnw2Df?=
 =?us-ascii?Q?Bs0Rd3tDK9C+tsPaVGQGh7dTGg0iHSAkAGxMX9v2DTd78Z5UHiwTSMW07mRm?=
 =?us-ascii?Q?i3zgYpwQiYKWoVjSlhzG8PCSFOqnhUo2+3QsuuXr6LCAFsY8bJbHOnifdylw?=
 =?us-ascii?Q?E3/xymcVLhjq83/0NHOx4jRnuaWQgqC1kLmXKG0NICcVVP3Fw3Wv8T1JZcOK?=
 =?us-ascii?Q?fEvcbntLIvxpqwjyGH45rZ3xDFUNiL1HoAP9YQd8HDIZK1D9ut2ofX3yjwUB?=
 =?us-ascii?Q?UUV7E0U7o2LIEVgWRNNUAOLEwerPU+IzzPoJIucUW9KK+FWmai0n5iS2Hi3v?=
 =?us-ascii?Q?MoAo1t3OhCrL/m7meZxhXsVavQ4mrl9IIaTYZTPPO258UVDMkDD3H34mFqJT?=
 =?us-ascii?Q?deD4nrzpAA5dnuSQXTlh418PosmgIXS9QyeFsBAp4PyzFysxMI4S5w5qHUO0?=
 =?us-ascii?Q?T+E/3mu2nmToXoCqseopA1p+LZ8vmpWvCntkLdvw7Ub+f/NFZBZJJBsRj9sb?=
 =?us-ascii?Q?XVVwx3NB8xyN7A2Luw2sVTZ1crXtTebgBKuFUf8kZdIbn37HxThQZ+sVt16g?=
 =?us-ascii?Q?Pab3D73fZ/GIS+2zE2u8TMoe7hl5nRt7XDyeYzXYvMHD1nc6CA7833lF6unP?=
 =?us-ascii?Q?V/qmSQ2b8j3yHknHbBvaTJk9Fgl8qrUjOLHqGsfjvOZrN55rcLi0V4M06g/8?=
 =?us-ascii?Q?iGING/PHncIOSfujm+enH6lnEadm+rJuNGub5yXZghLJebzfskJSODMlKMR9?=
 =?us-ascii?Q?wyztso5n6yzAtmgkOfXVkoRI+5j8tNI=3D?=
X-Exchange-RoutingPolicyChecked:
	cdFxi0zArlGOf8WcoXB+SkbCtOvebEJTG6YayvhB0wXOkaCF9sywRpCM0BOjSBtkptLzqlZxjqH0NE5mon5aNmyiopQWTQx2z6zvwc2zJftVJUXkgifdvFaH6mwYs45mf5F5x+vJiLK1K/9jfUlRziMHQcShOxOEmYWfEqyuAyJn+nidXI6ynVJHlTBeizmRQKbz9kliQL459YxCY/zaqkzG8wf8EAZP9hRlgA6eXioUiBoBy+58UuUaLAEFasOIGmVeMdIdA+NUqoqYgJPaQk/s4tRulqlcrPMgbVrjCdR7MsVxh4bYDvHY9njFUG0TfKEnuWvtv2pULqDp3Y4wXw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E92BMOVG0R6ZJu3B/bqGdO8oZ7zM6aTGn467Q02z45UhIJ1LEwu23zV4mx5pvDDma7rSRG9DZ8dsmP8CMXnlUqhibGKSlgikmm4zSLwSaPV2gtWGJYD36pkI3WNjge044f95O9y83Vurx1rDTWnUEg6JpFzF7GC+2wnXliOOrz/HdLXnEUcmJWZDIrO0TFiKiw2NaFGqmvrHKiP8J/0oQWUDJX6r+CIeC0625r+0JJHy5zcwNLk1KC6GjS9mOb+XRLqkxkwTSwUhbdcA2bXrqJqeIv3pyAYNQ9V2yZYk5opSrInWZCBOPqac27K96BKLk9CrrXcMaUZFvX6xv5PVXqx+o3tiHNRDzEes73kQDx+L4I/9w6JSJhlASmyWYHcK+uZjZhfielEFkTtMB/bkJMlOxCe0xx0KzRbDhNhiI+EuICh+2guW/s7yuvw90cO9iCeQl8uO10uQ21HjjqN0sINMm7z/n6VQbDsfQ9nh2m0RdFXyDZvEy5LwSm3eZ1RgAbZ3g0xD6KR5hjT+Okyk6xisY9o4TK0qodxCkI2Fg6pHB4dQ/InSpaqGMD5Ogha/y0pSBNs//5P1Vz4ZhI15z/Z69+4saEoWrXkQrT15Kn0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321c8268-ea71-499c-4647-08dec5a6d12f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 21:42:19.9684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: silKOktbmalCl4BUwdC4dFY4fIhae60E3OojC++2drvi29au6AkBu+s+4Ntm12ej5J1KGdb7N0fVZOBuT1vahsTjyLlPDd4f1XqJKyAsDeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8537
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxlogscore=633 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080197
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5NyBTYWx0ZWRfX8MkUHq3ISgoi
 Yyz3CwlysA56ZaYoW++c50t8G3Is6e5FNo0C1d3A5muzwspjL00+TgIAW0JYHOnJMszWwovdvwr
 p7npG9CqG/uw7IyPdGysosA9kv6m6HJC6v0XzslBWuUXWABCi/ZE5se0RfY/wbNq/jg0rahAagM
 aCehRmcwp8fS8fIga1rSx9QJPwh/hIQXqzPmXTksqD0jv3TNztdMc5V+bA9rt8tUrOOlV3DWnXp
 zNF/rKmhwXM18y335AnNYCTi10dpZB19L/g90QVDSwrXm6EOdlm7adzX1jLJVawnSNvI9ouZsbb
 OdKRf7BWULMrZtUdj/1L5N52Xg2xt3AcAeBLqJruNQLCEqukLhK7EDxV2H/y78/VjBQWZsGRqCI
 itGUi9iB+QvS8GAnydqb/wsF279w3yNROCVMLI3nav6/E8WLPFD10xWXttfOPBHgM6hesLDquXZ
 NrZHQfKlTob6Pq0R19Q==
X-Authority-Analysis: v=2.4 cv=ROSD2Yi+ c=1 sm=1 tr=0 ts=6a27373f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=5J27sXiRox_EU190h1sA:9
X-Proofpoint-GUID: -RjhwgGnwz7ziNtoVsFwaJl2l4y5oUkg
X-Proofpoint-ORIG-GUID: -RjhwgGnwz7ziNtoVsFwaJl2l4y5oUkg


Hongjie,

> A PM START STOP sent from the UFS well-known LU resume path can race
> with SCSI EH.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
