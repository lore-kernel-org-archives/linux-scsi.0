Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011029.outbound.protection.outlook.com [52.101.129.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EB91A5BB0;
	Wed,  2 Apr 2025 08:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743581293; cv=fail; b=D0LqBpUWYdjoFFErT0bm+ruurbdXEQWIKnqXmqMQpzEVGuzfiAOTmBoLCEeDfYbUTSyz3Tu5or47Htu1feq3ycJ0HW6yV+6CcNpMtSn8aHHlLclpGYMQSRieo7dFNz12AFE/P+NRx8su4IZexL1gA/VyQqKnQob56M06zDxs4H8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743581293; c=relaxed/simple;
	bh=oEcSnhK++AikjEFObSXyLY9Rn4o/bUSOFNXVaUbZ06E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A0tGFfKPn54UqTk+yn8QkF04qRJmoQK87sSTYcECVUosAQWieCxwFkc8M1/s+c56Yy/Q2AFE7Olqa7i2WlXeXX1jsx6ZTWSp25LZ30+LMvKeV9BAkMMVjc6Db2UuLECpkALl5n+brDWWV8FLk7o1J2pGKvvLtdPajS1Agn9T6tI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=gdA95Tz4; arc=fail smtp.client-ip=52.101.129.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="gdA95Tz4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jfQiE5ooIN3iQS5xNv9wKJ4+IK1LrA0F+8mCdSG6FZa6FKQRHsVshfsXz7DadqecOhzTp1QMkEDM1X+05KHxFkbB/UpxF+c1RRanI5CB8TRa7TUZYhwm0Ql9OmWQq1qfgJNbwMeiz5semdj0R5rZSmYhpu9fk6F6I7xhJ8bAU7zStm2gonM5GTto8ifiJCnz6r+c6vCCqIJUOtWXVyRRwhPO8gObHAM2/XSOxkFC9QKIHjSCJb6FgYtw+cp4n0yX4bdW1lfinuJbPMKlj3B1+NZBO1nLI8YcOVJXVkVAR+QrwJJpbEV1C6U9f88UM8PG4R92nCFO+kWJfdX5yqP8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KBM+z+wbtZBDT/7kMTQHgeDp3368XOrl0b/rCTUkg8=;
 b=hk2dv+dfHDByCqfRdbkJBEZWj6/iRr0ffoVRZnj4SPKkFvfEs4glYlDRDt1DKg5qNkiExveuu4YUCnr/3zBnoKlJgMaTdv/2SOpFBdRD5BpsvsC6QpKeNZZgg9QmxvCDXnJjEYJt+8hHzmMKBPK/B5uHF5rZdZyGWpayyHeGRFYVQGodUTH+loq5FlBrX3QEbAiXo0p3ojrGWD2nkKLsf2BlT/Zxi07CYbxxxmQEwt2wyv6X+/OkDO8QXSzsYFzsbRYWCvH4TQBzXwttGuxBKsCHxDnW/owgIQdcgfRl5Ltxc+rZmth1P2Q3uVYL0BfQXqDjcfwFpVI6u9xJpUpzZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KBM+z+wbtZBDT/7kMTQHgeDp3368XOrl0b/rCTUkg8=;
 b=gdA95Tz4WbR1MPcj1q2w5SqQ8LOI83h0roGnfYyvmkZ2z1NYWU99lYop4ilwv105+5IxZJIASDONlMBPWarm5c9w8faXJv61w8tkj+MYUVRz19KSVIj763Vx1yhz8eK4R7+qNY/e+CQg86DVZYuqxyDKbhjnTxU0wKrOhOCubxui6GFIZKJfCMcPKNfobYWpiafYmKGgWjxceATScPyIK7JS3njbHXN1K3juJG3X9UlF+CZmdp6kEaoyVEYwCmJQfmjU7MtU7C7QxTjTaPWv5mRrIqmQuRH55b+pKviUL9kF1Vja9p05a3BsG5zjmrXl7BQKmqRnwPJ5WnDHkZ/Rmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com (2603:1096:101:139::12)
 by PUZPR06MB5953.apcprd06.prod.outlook.com (2603:1096:301:110::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 08:08:07 +0000
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a]) by SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 08:08:07 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	ebiggers@google.com,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux@weissschuh.net,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_cang@quicinc.com,
	quic_mnaresh@quicinc.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v7] ufs: core: Add WB buffer resize support
Date: Wed,  2 Apr 2025 16:07:57 +0800
Message-Id: <20250402080757.449-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <467b9ba0-5dea-49c5-ab43-435d3d3fd6bc@acm.org>
References: <467b9ba0-5dea-49c5-ab43-435d3d3fd6bc@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:4:197::7) To SEYPR06MB6279.apcprd06.prod.outlook.com
 (2603:1096:101:139::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6279:EE_|PUZPR06MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: e39a5872-086e-4db2-d2c1-08dd71bd8019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QhaRc8I0v/iDcNceUCuDV63ifOelE+k2Y9yYEf9wQYkcZVKlHNzsxyfXr6OX?=
 =?us-ascii?Q?s4csHNWbwmragmY1NS3YPV7T3MVsvBYl/86EAcz3wE3pQdDpXj8UpT/rQ8yx?=
 =?us-ascii?Q?JqEKjZviMFBnSluR+vhq1AT5iJtEhHeo0hRkRSN3VKJwpYOwMYTXOzhLnIPl?=
 =?us-ascii?Q?jKEuObiR9YqvoMboomMLZmdaupWK5G0EajbLI8X6jTyWxIgBMKqPFjF+uysF?=
 =?us-ascii?Q?e5vzfHWibfoQhl9Ehrf6XWFMCa/eQNrDIM+2iSIzblBOnWQjzO99L9DD+qIr?=
 =?us-ascii?Q?8A1OzCJ8IvZWG35u4kSeIeyNcmtZnyL8gpkzvgqxoTisFvsnSfbzqfwZaF9l?=
 =?us-ascii?Q?ZS/bm566uIX9tmmvO0vsz/hDssWRAIwNl/3uHKU4ZBRoxWMjXTDHFuXN+Ol9?=
 =?us-ascii?Q?qYat8jNCPzIjEIAvg5U33dOfH2g9NbrpSLrvPLSf0A6a7dxEsara8Wey2DWo?=
 =?us-ascii?Q?q44Emh07W47TwgOo4ThwEdVeEyZJazH/pGrqr8sfGll6dTbeg1KUckXR1s31?=
 =?us-ascii?Q?fn6NkkSKUnMa3qIuWg/38ZyxrAD5pD55maEhCur0PemQvhcbd7VFNHNQWt8l?=
 =?us-ascii?Q?VrGjkMcuQL3bQv0i9tvJ6SFp3aMrFS2rK6wrYvHNscn8mOjHBLU+1TK2sOhd?=
 =?us-ascii?Q?J7ZO5wQ9djml7Wxsz94GgO7LuLBFBtweopgAlulY8ZqsYwOvv/sm9M0r4VK2?=
 =?us-ascii?Q?wjs9lgNvO9bvAui7PB+dwH9QgIVrBP/ZGYS+RFyp1g2wwQyA/DFBm32QL8lE?=
 =?us-ascii?Q?4XI1Z/jgdb7om98Ho9eoZIR3x9mj+MS37RS6IHhnPiT2I8c2U9qpvU0yS2HM?=
 =?us-ascii?Q?NMM52z2OeLHzOYyHYz4IlotzKF99tClL5Sbi1eHtOG2TUIcy9My/MYiSFrkU?=
 =?us-ascii?Q?h7hQ2DyXiBuHoyDsCF5W39C563fZbVKrjqble66BKBuofzP7FfP9cCDycdsV?=
 =?us-ascii?Q?1NwgYtXMbgnw0pr/yUmJdKOrWU0bsvPu12U3jn+yJtK9XxV2CJItT8KXXSqJ?=
 =?us-ascii?Q?9yxI2fuQwN4LjvbH9FSMpcegUMQRf8oCKB+THiEI1CRqbHNXwW2bHEwD6H+M?=
 =?us-ascii?Q?syC+lo7jO4SIxOtiELmcNnXnSGsRcvuNsLroixG8tBv5sOiEyrIRgCm64Fiq?=
 =?us-ascii?Q?+cWt41yq2Q3a9kosscOJ+g3RMI96SAYAu8THwcWLY9wnKSQX9THOyBKO6KaK?=
 =?us-ascii?Q?gPvhCul8fggCYmlUoMimk1JksYqSq43f1e7VVbNoep1uP9fZlBxVZQvrdSZi?=
 =?us-ascii?Q?1v41DXVAYbd4+qb0O1eK0u1RjT6yUoq87XhndOQZzXqw81xcRfpZFl+D/2jq?=
 =?us-ascii?Q?8y2ZNa7XPqYcdmV5+R9ounWc07WdwwYG8zQuBGScnM8dJxGlgR3dQTAklUP1?=
 =?us-ascii?Q?eVG2ZM7mF79VpxpH8PBjBaK4lltx01vUDDKmlHnehdqjnZWXak+4WSLQqzU7?=
 =?us-ascii?Q?IbX6qLNCx9X+VLhf+m20iABKiEUMmwMAZl88egc1wKF7/gc1QmfopC0TSDBn?=
 =?us-ascii?Q?zGVG6DkZO4HM7eI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6279.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BroDbZTmIaNZVEc9PlpK1BR114dZYLOshJUXieyrY9ElnFZjsjfq8dK6H85B?=
 =?us-ascii?Q?LZvxfTt/wRAns9KXeB/ZVMIjF9vIfyKzWzrJnuB1k81GVeCsC4xqUBlu7/jl?=
 =?us-ascii?Q?VVZbTVFYgXVqAVUin0KQ0+7g5/wft5Vyn/czCw8+b9kVbElp2/wKR0QmsKwk?=
 =?us-ascii?Q?zdLldmujnAAxrhpmII3hyJhG3yYlpk9Bbbeyz53CQE1ymp7o0XV1A9IdIZAR?=
 =?us-ascii?Q?hvARlo4wJG2qwZniaOt/ABMEmG9d82C+X7P8eAyo4wa5FXcDEvY8juS/qBHy?=
 =?us-ascii?Q?Ox6ncjPmT6M4tJSGpqL290l2QqFv8u0Oufwow8Z0JnRWG7MIqTRZ5y/5+Zy7?=
 =?us-ascii?Q?W/pho5L1FZ6Jzsq7kp5L8ftrZ+VN3Hsr/Fv11cf2xLGeu+9YjpevyIUWtT00?=
 =?us-ascii?Q?wSrmNOIiPnkcIQ5FXbu/jS77SOCimqvB2VfPcMQcG6RNzITHZzVKb9NYRPOD?=
 =?us-ascii?Q?Eek3qRScomXcoigZlgz90BeEwMaysViS+57OAD70PAH2lhtjn90D5lFisiCK?=
 =?us-ascii?Q?RadtTNFX4ZWQv63i3/bGWqKOLtAhHVOKx0szNZ3W56VDJ7F68yRMAc59UD1F?=
 =?us-ascii?Q?U0Rn/GJwpQY0qHm9sJquHlCFa8oap9nqbs+cLCqRP300CDJX/hItvvEIEtiX?=
 =?us-ascii?Q?qbnGT/qufKSF5nA7owEI/DXxJbhmpWNuaWGaApEbteePTH9gOEM4yFze4pYT?=
 =?us-ascii?Q?yZn+fayeK/YlD/j3oXixXCaQpGRXK4Ri5VBsqfWxucTK96iLuVERqTQ9cyb3?=
 =?us-ascii?Q?IrEQZ0snuGDG0efpWhqNdzkzewuvMzJ/2gmYT6mhGnmpYOVLHA1DI4DWFGkC?=
 =?us-ascii?Q?kYBZgcZXZQVQ/8djp6dLR+eDwdDMdBK9IqyHwoH++du3JkbZw/5TbgJ3eRIo?=
 =?us-ascii?Q?oqOG56gGCiDx4RwMq8NAhZi5q4LTiEVu9sTqygAKf/ztMz8lebCKdJROsA5+?=
 =?us-ascii?Q?SdoBf0pc4+gRtGenE5s41xOtcE9AXabpmD47uzZhTscpnpMuFO9BtttGfKBV?=
 =?us-ascii?Q?KgzGS/ydhprUo4bg/EU0WpIjmbVFKSZn4MpYdRwqbZ4cNqmszqNqPvDvBm1Z?=
 =?us-ascii?Q?YJ9wg8k0NH4B6PIVT6uglN/Ln2BR9FOCMcJJhrJCQP8mUvZfDDxP33w3WS+v?=
 =?us-ascii?Q?/l+GuZ+AQ+9+AxP+YNOMP1hQYsBW4qHYQoQ456c2TE9eAKjfdT1W1KmWgUWy?=
 =?us-ascii?Q?ckToBhY+9AzkRbQvjL2+tfQ+5LNDzEzmfmDXd0Ipse0IU100nQjGAvOf9DB5?=
 =?us-ascii?Q?MfeA2vU22Bzs+K+5CBJQBynvlveveFdaSEra72jTEhRRV/+GAI+y6LNun5iZ?=
 =?us-ascii?Q?4pS4z6HzmmgypjA4BhrakItpBVbfE/L8kV/aoSLfed2kBNkUpmytDDoCWJ91?=
 =?us-ascii?Q?sEZu3rRjlQoiNphH4Zh+a583tAAdSaagOOESa2/Ks+D5txN+GW6gEKxsVVWK?=
 =?us-ascii?Q?9RD/5YHnZFgA1ranRfPMVDvGMvl2Wfjkg6Xhveg9hTdTb0sOXeLU1XNGPcOm?=
 =?us-ascii?Q?1vpRI470FZZwLfEbqezjwK3cDc/p7phTl3pzf7IOgJonuuxp7Md6Yh2hk0LH?=
 =?us-ascii?Q?5vciLAf4guXSP9cxhAfQqHw0mWUrUyiSoarGn9rS?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39a5872-086e-4db2-d2c1-08dd71bd8019
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6279.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 08:08:07.1902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVivP1M8tWQqUggPsdTkNs/yGMD54NE3Jsyfwr9T8CZt3SCeq9dz58RsFFN+wWfkAvhhgKgiKqadeojen5POdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5953

> The description of the attribute contradicts the name of the attribute.=0D
> Wouldn't wb_resize_enable be a better name for this attribute?=0D
> Additionally, that name will be easier to recognize for anyone who is=0D
> familiar with the UFS 4.1 standard.=0D
> =0D
> To be consistent with other sysfs attributes, the names of the verbs=0D
> should be changed from upper case to lower case and "Others - Reserved"=0D
> should be left out. This comment also applies to the other attributes.=0D
> =0D
> > +static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hi=
nt)=0D
> > +{=0D
> > +	switch (hint) {=0D
> > +	case WB_RESIZE_HINT_KEEP:	return "KEEP";=0D
> > +	case WB_RESIZE_HINT_DECREASE:	return "DECREASE";=0D
> > +	case WB_RESIZE_HINT_INCREASE:	return "INCREASE";=0D
> > +	default:	return "UNKNOWN";=0D
> > +	}=0D
> > +}=0D
=0D
> The formatting of the above switch/case statement is not compliant with=0D
> the Linux kernel coding style.=0D
=0D
Bart sir,=0D
=0D
Thank you for your reply .=0D
I have modified it according to your comments, as follows:=0D
https://lore.kernel.org/all/20250402075710.224-1-tanghuan@vivo.com/=0D
=0D
Thank you for your patience, please help review again.=0D
=0D
Thanks=0D
Huan=0D
