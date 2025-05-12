Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012037.outbound.protection.outlook.com [40.107.75.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453DF26157E;
	Mon, 12 May 2025 13:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056933; cv=fail; b=qIybbClgdZeA5l5qbYC5fpdShZNqWUnEPJ+dorSORSSWBctVdfBmyMpeWhwRZdsrGPQjgtXkwZk4EVLPAYuKF6d3bgKlB9ZtiFN6/CzSi1UE4XCjejxb0P0W1Q4PsHOiIdw0Og0RvWHeFfWb6wepcu5r+1R9oCqL/JadKv9cFVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056933; c=relaxed/simple;
	bh=q0khmzy433XSFT54vyZnVEmOf91iRvfvR8A++K3CgiU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NZClZlk9mMmLm2dpn+LDXfzETNNj9Z9SPODz5RZnc9ZkBW1mW5bueDdU7Ar91f62AAMVyrSf1QheaedqXovvJTwZxGWbwyKQK2T57rB3an2D7pHN2fMipoZ017PPDvw4ThLOuCPXbTW1axnQKsQDesjHXz5pv4cWJc4MIvI6l34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=p7LYY7ce; arc=fail smtp.client-ip=40.107.75.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="p7LYY7ce"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wjTctR2GCgHsk7VCzDHnSZet2MrmarZqtNyWNL9wB3IEcZSpCfhFO7h0O3yn8JJUAlwFHEkuMvA8Xk8Ego6usJMCoC81ePZGx9HLhh0yilFa+UvchHZKF4uXwQ5fmcqexP3BmcOHq1jUHQbqh50C+Gu8ihvM/gaUp7O3JJ3Z1tuwvItl8V4nWuZ9ic/IFpOZ4oyK6JSP25WW18b5COBeA0U9BvOXn4d4Sp9NC4wnR/wqb5sBsIYnrImEZcKO3i3idAQzx3nH7OaZSOrZN6L22xrfBiVI3okVUOWNRIIeeDqoy/pVZK9NSOT4LKwHohEwoVeWjtln2UCJIM04+Jsk9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgh4T92J4Al2rDkD52cPObcKNzbmm1pjfoEZ0Etf9po=;
 b=PcJDT0+ijra+dxTuTD5w/7R3DS4Sa7fIGne8ufoAQhYofZiRoHJB3CQNPs4Vu3rvD3R6WtpTs7yg/KaYUZvUY1yBdJMsop3ft79JWmjLi+Sl3Im3AL5fT5d9dGf3D7Buho9l6h8L/2YKkqKKIH0tvfaFZ295wAFENak8m+ZpNZP1jkjR9d9IX/MH+czH+TF6V41nczxTj++6hPDAQB4PbuGz8dXuU/TB0Z2sY5W7uZctC6SnPqBKwo2+ZQiMHjoJTNkTzKhkT53WodrXnD3PPq++Qw/+5kBzr+c3WIluMVv5h/k2lBSEaNQ+IBg75TLWPXsgTL6NIRRRb4kVBaubZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgh4T92J4Al2rDkD52cPObcKNzbmm1pjfoEZ0Etf9po=;
 b=p7LYY7ceT3viHtQbSdEpi3f6fHknBcuk3w76jZs9xMwSpk+aMNc5Bp+gLYEF4DyefBgsF/hDo+jvxWMFJBqul9OX4OkyCwVn+OTzsI+Ehz+wfLbRb/kI2hvC9UVxABvXUlnvO2fP2eHFp/qgUuhFDK4LNlboSWkgNnBCINVWG3qZFOTj0fNw8KjkwLROxzN3pIxs9CBmjecgARJ9JT/V+q9z+3+4BrOVjQoDP8TFCRhAzNm7KP1Su5Ww2qf0t3Wty1WFbsS/kzy04ISlj9xK+sFSLU7yxX94ufxKVkPEaSh2AGvHKuF6ZkYd1ddEfnrNx4FgQ8I+uDmI700MNLPyIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SE1PPF93ED7187F.apcprd06.prod.outlook.com (2603:1096:108:1::420) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Mon, 12 May
 2025 13:35:23 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 13:35:23 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	ebiggers@google.com,
	gwendal@chromium.org,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com,
	quic_ziqichen@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk,
	wenxing.cheng@vivo.com
Subject: Re: Re: [PATCH] ufs: core: Add HID support
Date: Mon, 12 May 2025 21:35:12 +0800
Message-Id: <20250512133512.188-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <4eef6172-3ba2-43a9-b6af-3750c39bb344@acm.org>
References: <4eef6172-3ba2-43a9-b6af-3750c39bb344@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0070.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::14) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SE1PPF93ED7187F:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bbfa2d0-839a-415f-cc24-08dd9159d8b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QaROrucsBOKDiMBL371nqBmksheCSayWMEeEHZ/eJz6ZQ5UWaw+I/HP6kl0h?=
 =?us-ascii?Q?Yj+suYEUIC+5sLsNEaeE3hhHS37g5y38kncF8WwHB1qa2bUDxtmSE5uXKEFb?=
 =?us-ascii?Q?j7oNnLk7Qf6+wtoEwnGCqeEVFdNQBsd9B5+ohXjm4g7B6dYV6h8qa7lDeECE?=
 =?us-ascii?Q?za245nGmFlWK9vhbtdGkGjaUqjtaQaBrQAtOteFSOF9ZjfJ/FOye/5pkEi86?=
 =?us-ascii?Q?uJ+mF2kW2XrmXTXVbEu/6b1m+oMDzJVQoqn9sH2uHJnSUvLXijxj9DsOrbSX?=
 =?us-ascii?Q?NO3Cvtn59uGSOUfRklyGcPqmWGhLTDzetyn2e7SEd7nbPIM3Ljb7Qusf768p?=
 =?us-ascii?Q?RIkzCr95G2b6n6n1tgn82oIDq5KR+ptaa5ZEZC00Y5B37Ttaz28lFXbk/Tli?=
 =?us-ascii?Q?DHvT1A4g3VmMfDvTTf410X/p1clvg2qH5PdZLnu94AOyIOiYy5XnsXqu2rYo?=
 =?us-ascii?Q?l1U5CvE+sx8tMa6Bub0JI3K8Ly5l6eOY3W5D0GhPuWNzxW1ez3rUbThKzHoP?=
 =?us-ascii?Q?1iEBf7Yew5WwYcdld+ceXLEKTatFKTxWDOHBCgdRwlEFTpF/Jl7is9UWcgWF?=
 =?us-ascii?Q?COMq7uftxt7yBVHZk0EV1YsHEsJ3/k0O7VXyK4glqSr8s6ub3qjWXdFBgySB?=
 =?us-ascii?Q?yQSYwSwTIhFI4GvEy1UfiUgdIXmQl5AQM++zNZsUTASvaq0yrkZiXjIoMzEU?=
 =?us-ascii?Q?1v+hrJy/NTO3T45/ALp5rWh/5HbAC42a2kk3hbwVTKt8yyrfMpBCpNuP3R2A?=
 =?us-ascii?Q?bgPVpU+ICzmj5V3DcGrfAHfjvcGZPxXzUUQsdEmkg7ejHY5RHzXC5Vw4iHt3?=
 =?us-ascii?Q?FJl4nfYfSJz8JOr9ebS3yzWiIs04eNW+J507YAiqMWY5OhwnYLUB7xbvyByI?=
 =?us-ascii?Q?eXiap+cEZGdCtZd1FwFXBWvTV+AyHyvYJ5vvzPl6KE971Tm5Qe+z4EsoiAdu?=
 =?us-ascii?Q?03rugbn8Y6EPvMGdh9psyG8mI22M2++HgEIs4rVHOQzG0qCMBRu6ZD+cjHwk?=
 =?us-ascii?Q?hv4k7DM7JSsN5dGJe+e6s7nZCOjbBvVq5p9nF142DUZjLdQwhlFgRA1k4Eer?=
 =?us-ascii?Q?EERSFQNCLhEPUP4JhSKuyKIY1euYDeh+VWZZ2GjGwbCxwydnKPKuNILhYyHH?=
 =?us-ascii?Q?8A6nencSgqblTmnpPN0BEqp62PBtliFS/2UcLkOcH75OOpqQJTtPVlZyJic8?=
 =?us-ascii?Q?B8Pjt/mw7IXPSwiUSlSEVf+CuiBUC5fh7M5fiAhC2UMBOa96SkYmv+oAJOsz?=
 =?us-ascii?Q?k2UpqYqReERM+bq5A+Deh7nMdtlMsNdYTI/UtdkPtCDlreI+MxYF+K2YXGfK?=
 =?us-ascii?Q?T7Gt6S2dvlyi7uuBuLmYF4gWpMw2fzSMDx+nspXf2gcv5Xt1MvWFHNlajw+v?=
 =?us-ascii?Q?GfQBL6e6SHcQk4d75gkYo4V0NYgBGfX1kCUXAeN5F6SATAwNEO2WTANWD6c6?=
 =?us-ascii?Q?Cqpi1mR7sk6PXzvAKD+ddSYWv/lklA6yIsqRtzDKKnXJ0aUx2EMt19CbK/5v?=
 =?us-ascii?Q?vns9Az72oJF+AK0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yRvHemm/skHZSVOT1jzr5DBS/bZUDccITyvHqXgow/o8y17swZGX+YdgzYVZ?=
 =?us-ascii?Q?8ZPVZVgFpKLZujOINhEDPYtTPVMSWpDnJHpPc22rwtZ4633+QQG5ffRa2wnn?=
 =?us-ascii?Q?ndjjdx2KvTdPHIvo8dtA27OK6bE3kzsQ1XGzB7rHS+waSaHvhfOwjNtlArJD?=
 =?us-ascii?Q?raAcUO2M120cUxg3z+Q2IpQ9G7UvwYSpy0dLKJmPqAV/DTqXXhzEeCU6sEJN?=
 =?us-ascii?Q?PVk6Fjluu6H/qCiALkomoMWYQkMMPFGUkNn08LbB/WqV+yS99irhIBt0Pvkk?=
 =?us-ascii?Q?bEZee19aPpU8ZkFlwfhicev+0jt2dVKLzE4Jh2nfQLiPyHrDtqwxzPl6tCq0?=
 =?us-ascii?Q?jrFtaR09CYdvXPMURMfdZUx7jKrSlkKkbSg+kdRxXQ3w0o5/Ph98EiuJPSNy?=
 =?us-ascii?Q?yyQN0r+9UEiQroaM+1NIlt4nYb0uQDAtV0VYlMHcHAUXu7qBRxanJrWnhzrN?=
 =?us-ascii?Q?nTOOZMTp21+TlqGJTO0xuURA2dwkbjDmi82EDDVSOWbddLJegHZZj8eyB4to?=
 =?us-ascii?Q?uCnDLJu160lk81hfElFQQiTwVkMtGUwYxLXFB3ANAyQgS7oQJjhSzzK8Wwtc?=
 =?us-ascii?Q?stA70jol4yd8cHJHv/LCtHX66T92YNKoG/FpB+YAWihBisAmbVeAeaL/Fx+7?=
 =?us-ascii?Q?RjUY/6sU6+ASDGVl1W+aroAYztfVbcx2+A6kAPg3cjpw93f1pBuytbtl39SH?=
 =?us-ascii?Q?BuMyuzb2JBex0yVu1iWaax/EkrD6WDruilRSt/3zXhSmD4A7/5zHSOGfzFu0?=
 =?us-ascii?Q?bFdXnOXWJIf/RuhhAtA4y61Zyx1qDapJOHTHe6s5v7PBPtervQ75REvahcNt?=
 =?us-ascii?Q?H4liNBaMZJhXpMI4QAHOA6o48v86ry06Th+zya6ZqgyxLJNdPu9wUKajRsPe?=
 =?us-ascii?Q?LwpphYrbG1jJt2GuazQOolXq+rpJjgjTeiNTk9wLl8HBdDw5e502X+5m/EFK?=
 =?us-ascii?Q?TKU75nkjfhoa71rk6YdxLp671G1ZpJpOIkpvDC/iiQOIAKK2UQbS94uq4lng?=
 =?us-ascii?Q?R3I+GQfBfR7bRtloVavFWR3XLquOvhpxjJe+muHH+H0BdzY+AtLfC0wiBi8H?=
 =?us-ascii?Q?Z7Xln8SAEYpqxG1KmIAxHr1d2UCwe7sUkdO4xYKfmTys4u1YL5vRwTiJCC+L?=
 =?us-ascii?Q?QNS8J+bfFZA8PJoHd2/wlUiii7A8s/aKv7LE1b85qBC4RDdrUmP++Qigu6fk?=
 =?us-ascii?Q?eTGeXxp2yssKGOUFddFNQ84NZcGpT+7ZJSmM9BqKZCnFnoTmGCcudrcUYAkl?=
 =?us-ascii?Q?f6AQ2QktnfnY/6JItM9CI+cB14m9m864IqtKn+O+hvCeO5Mc+Xl9Mhf/B0Yz?=
 =?us-ascii?Q?tQ/MYuf0uZY12d7Kakgt0ZpvF9ipHf6d2+meabI8siy+muHb2YVK1Fe1DLLN?=
 =?us-ascii?Q?9HlV/9VRUjRpFnJoTzWKsA2cP/M9WTUf2NOtemKl5n3KoBACzmeB/dagI/3C?=
 =?us-ascii?Q?FLLxY0u1bO55A6P461cIG4ihRhbQpeik+MLzK5DYY0UTontFT/G8YOi2fYMm?=
 =?us-ascii?Q?+2GG/yNNs4dtRI0msKZ0hpWC+Lq0HlBc8eubAdZtvAmuOsxl2U1DbfSt7KxP?=
 =?us-ascii?Q?rSzfuGTv+yzwd3vvJ+jJRL7s7Y90UPD2IB3CWNzO?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bbfa2d0-839a-415f-cc24-08dd9159d8b5
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 13:35:23.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BY3LK9qDSlwdLeG0Kl/Pu+OyVK/6P5McwSy4DVI84uuLkL0njq5lyd7hmYxsPjd5g0HiasBX0Cj7teYHT08djA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF93ED7187F

Hi  Bart sir=EF=BC=8C=0D
=0D
Sorry for not replying in time. Thank you for your comments and guidance=EF=
=BC=81=0D
Based on your, Peter's and Arvi's suggestions, I submitted the v2 patch:=0D
=0D
https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/=0D
=0D
> Combining HID analysis and HID defragmentation controls into a single=0D
> sysfs attribute seems weird to me. Please replace the above two=0D
> attributes with two different attributes: one for controlling HID=0D
> analysis and another one for controlling HID defragmentation.=0D
=0D
In the v2 patch,  use hid_analysis_trigger and hid_defrag_trigger=0D
=0D
> Please change the name of this attribute into "hid_fragmented_size". I=0D
> think that this alternative name is much more clear.=0D
=0D
Already modified in v2 patch=0D
=0D
> Please make the name of this attribute more clear, e.g. by renaming it=0D
> into "hid_defrag_size". Additionally, please change "defrag" into=0D
> "defragmentation".=0D
=0D
Already modified in v2 patch=0D
=0D
> Please change the format of this attribute from hexadecimal into=0D
> decimal (64h -> 100).=0D
=0D
Already modified in v2 patch=0D
=0D
> Please change the format of this attribute from hexadecimal into=0D
> decimal. Please add an additional sysfs attribute that provides the=0D
> textual meaning of the HID state such that users don't have to look up=0D
> the documentation of these codes.=0D
=0D
Already modified in v2 patch=0D
=0D
> Here and everywhere else in documentation that is intended for humans,=0D
> please change "defrag" into "defragmentation". Please also make the=0D
> Kconfig description more clear, e.g. by changing it into the following:=0D
=0D
Already modified in v2 patch=0D
=0D
> A blank line is required after the macro definition and also between the=
=0D
> declaration of the static variable and the function definition.=0D
=0D
v2 patch does not use this=0D
=0D
> In new code, please order declarations such that the longest declaration=
=0D
> occurs first ("reverse Christmas tree").=0D
=0D
Already modified in v2 patch=0D
=0D
> Why is auto-hibernation disabled here? Please add a comment.=0D
=0D
Some UFS vendors say that AH8 needs to be disabled to run HID=0D
=0D
> Please add a comment that explains why the ufshcd_auto_hibern8_update()=0D
> call is present.=0D
=0D
Some UFS vendors say that AH8 needs to be disabled to run HID=0D
=0D
> Why the hexadecimal format? All other sysfs size attributes I know of=0D
> use the decimal format.=0D
=0D
Already modified in v2 patch=0D
=0D
Thanks=0D
Huan=0D
