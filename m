Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27591DFD8B;
	Thu, 20 Nov 2025 03:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763609957; cv=fail; b=LXd0IFDeNIAzygUEgqTnOsgym5bi1T49tpB8Wv5gc63KOV6/FmzUpVzwvguhCKjH/J48AlFqBqExkFBjMMsaFgWZcdCWAUEAUTD/aUuwEg3u6FN3rf3oXNzZmZFhZxOQWY9wmeLMeO6YBKhQOETiFpZG6NTkPc+DddRAbyDTWBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763609957; c=relaxed/simple;
	bh=BKIKmzbdaxIi4lGgTRpILTkDT7nHr6JAWjMNxY45w/o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L2FIP2AgwJ1N7HcwH03r89oJAtE5Be3K0GnJqFQ/z2BG6VG7BevBM+zKLFKT92iaZ/pU5aiN4wV6/lCStE9a5+A2gTEqg4Pe5wRO7Q6wqVtpxOpbqQ66FoZOO9lr03mpBbYjs4w2/dRRIDetDgsJTWRCYiGxFe+Znfm8N+COLao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gzRpN8PD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sE760ftD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gzRpN8PD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sE760ftD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NQ6c006748;
	Thu, 20 Nov 2025 03:39:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n32M7BQR/Timo3No1J
	Uv9CrPO4FIqdT4X421H1lELZA=; b=gzRpN8PDiP3qLdElNt8Vlu5YVQVXr37iO4
	uzfGGNhOHwMA4Joz9+lnOjz/G4LyH+j9sVZS2vGXeA9+WRl6gWrP0fCW7BhEhqDi
	Krz3Z+ysTSk14Frek1IPqxZpJRbJHonyoNKm4N2Zzl9I36V/UVtBcPM1pd/j9Mnx
	PhBpi4ZV8Py7lTD0pEjkOKENEXrT33FKxZimU97B0TvWi8bBtkzGxL2HmsS+vjIj
	X1ZS2lq8gvpEFm+oAWwaiLr3KAWgJg0hDwtzcBr6NmoOuIGptzn8LkA5yqMdOTBh
	ZCx65qQIWt+0bNsEi+jVrfpcXPn+zfc3pwJh7tObwDz1DIGRZd+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1g991-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:39:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK23PVQ004483;
	Thu, 20 Nov 2025 03:39:09 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011000.outbound.protection.outlook.com [52.101.52.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyb84eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:39:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZNQswMFLFSOsYYVM6kCXMmS6Sc2xiexdq1h8iyXfoX0xm8aBl5x+1w4/ovvqbDbv+sBQK+SBlya8msjhHAXRvwjWTMTkzgxC3jICztqhGSH/zUidL7OmmhlTBn5PYwGIWNhFDebupa3to2+8N9xa2SJVYDVyAkjGHi1kSFZoodWZ1bB1cF6mMIpXMMzqVc1QjxnhrzOOr31uBsFijmPUTBLY5u1Fw2WYGrTTdFzaW/1QNioMzgtvmjbs9g78Giz87YVT8tLRDc4YdsP9t9Xcc25hkCjtzEW8ZTuF6tlXhDqSEnERGQlukUHrpCX/+42CyPm7ruB60L5zocCEE2kqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n32M7BQR/Timo3No1JUv9CrPO4FIqdT4X421H1lELZA=;
 b=dYuDbihZ7zbrprWhMBoxXcjhxn7c+0aqqpFG9Rctks6HFMp2GIGUFhXDzuSFaN3vBbQQBdtlp8/6a5SadyxXeDwkSEovGWYeF/drkLExfnav7Y5dem4Nki3fLYAZOl+SKewABm1yM6aUn4JqZwsZdM3LhmhmrarLu2eOjSSfrxgiX9FlJzLDGYLZTJiiD4KxwJ3YLJre+l99D641wGBVWEov6An6H8VA8UhjQyyx+sbcO7wyKOp5YMkEW0Dt/0oseCfFoJqqco0XVYxTyc96/nF7U2I+WolQ9WuCBZG/vX1lgmWy/4GXR3OoiiLARoGwVcAXCMtG361wcTHeqZ8WMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n32M7BQR/Timo3No1JUv9CrPO4FIqdT4X421H1lELZA=;
 b=sE760ftDxLVbokdl4KbFH/UAnuPJNyBerlvpBaRmrWsiPON1UH/NeoPhaxO1CSTLquNfXL17s/r5EBOop5r/FD4ffi+aQ63De9Bult2/J3iOmQ/BFbBGOqsoTfvqr4QlMC2HIE5UYViHGu1mHrkPxIUpartzaJo+hz8M5CDqIQk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7322.namprd10.prod.outlook.com (2603:10b6:8:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:39:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:39:03 +0000
To: Zilin Guan <zilin@seu.edu.cn>
Cc: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] scsi: qla2xxx: Fix improper freeing of purex item
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251113151246.762510-1-zilin@seu.edu.cn> (Zilin Guan's message
	of "Thu, 13 Nov 2025 15:12:46 +0000")
Organization: Oracle Corporation
Message-ID: <yq1wm3l8jaq.fsf@ca-mkp.ca.oracle.com>
References: <20251113151246.762510-1-zilin@seu.edu.cn>
Date: Wed, 19 Nov 2025 22:39:01 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e41213-05e0-4996-0bb8-08de27e65995
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IBv64nBEGgLT1ITlFAVmTdfBp+uTbEKg/cqj5MDfnXwPlcAW2Ni9ALPVLTWV?=
 =?us-ascii?Q?+EuZLCRYMdYZZWICsXDSyrbjB2w134Ld1faKW3/vBsopZ74lUDE4anSVCo+X?=
 =?us-ascii?Q?2vNHZ6zsicNFO6082cox8a1AtGcnilwKDQiT1z+f4wIy9DLubmE66CQJyt/3?=
 =?us-ascii?Q?mcTuWFMz8bAv2Ri8KOUfMfvjDeGOXBw4Z5+sK5cajgTVaIcsRNXl/SYhI57t?=
 =?us-ascii?Q?Sjgqss4fQc5+9/0SQMYIiyx7gKBgUmTze6jSyDg4Fh88jVoCLMcqAXaEv/68?=
 =?us-ascii?Q?YAe9R9h6CQqAAf2N30KT5Y/kcjs7ZkyFUQM3uPvlLN6PhubHFJGeeSbFeE0R?=
 =?us-ascii?Q?ICquQr9Qmb5DrZPhZ2otgZJPdsoilW9CebqOfx41yOwvvglAEJqxjTjRk7P9?=
 =?us-ascii?Q?y0PLY8vfuFh5Juvx+AfZ3zh4itbCBhZ5y4aB9c8chh0Z7IKQUzE9DOkcSkTl?=
 =?us-ascii?Q?co30ytydcV1dt6ARIK/oPJkc1Ni1F838MNpRz38he7EN+mQ4nTCGyPs8fGQ0?=
 =?us-ascii?Q?Vt/qJgY7Sm7yNCySThuxHMlFB6hpZOhPcLB+phfFVzYx/Qh2IXHmnOaWUNpC?=
 =?us-ascii?Q?B2t7DDpbRtf/QaC1rRUYYVuK3VhUfqBBpBC24/n+O4YKk8gPmKaZZL2TCpTN?=
 =?us-ascii?Q?h0ng+/FXSigkH88Au4QTjkEWEByjCCMv1LkQZFtyptm+/lAlKjpG3wZqfPSz?=
 =?us-ascii?Q?/DXK2tA37Pc8k7ujQ0Sc/46A37ZI35zPPg2Jove3TIx5701TiF+1FTEbPewl?=
 =?us-ascii?Q?lpxw3qGVIqzhvej8SW5BO+aKdNuex1oUmaNUc183HxORieTDVA4fqLsWNWJF?=
 =?us-ascii?Q?IwV+aaPVWyZgy6Kgg2uLfiQXMXuhny3TyC+f8hXmtI/IMyJlMfE5pEnFpN9B?=
 =?us-ascii?Q?1sf2FBIUx2P3Bx/Y1XwRAliJp5GH85oYH6WNej/9Dh6Yw/s57IytsA/pX2+G?=
 =?us-ascii?Q?VJWSvXVZHDz4y3j87/00RT5RAJj8LSmg4S5daATEwBzvrNJMgDb5VCCtPIcH?=
 =?us-ascii?Q?7eATfPei2nOeF8BmRdZoRo8v547tJxIWlELMqd5lg2kSl0xkBguFiHZ/zGqt?=
 =?us-ascii?Q?LlnroKRrykyxWPFntosSbA5Bvhc1T2xsje8RbwNP7QuCC/4+NL2R5s+kcOM2?=
 =?us-ascii?Q?TkVT4YWcEIGIUFBNPtufQiGjYyMnhxWeRaTtAIOG91gWBoQL+d+2kppsXBqg?=
 =?us-ascii?Q?alEpsWcMtpu9nDzSzjOZmtB5Z0Lr/swCZb9qI79Y+9HPJhPQ1TYkXCtjPytN?=
 =?us-ascii?Q?8UatNE9UU/1W/rEzuVDk9a2di2aas3oGxnc7Mx2a0IANmprM8/6T6NdxPaZz?=
 =?us-ascii?Q?jXN1TJTCSlSNIWF2IxIk0Jymkp543um6jP9QgHCta8FoTz6Z9eXjgM2XB0Nq?=
 =?us-ascii?Q?Oa4u4VMkRcnV1GfNOg72e1JnYjHTJzFi/804jgCC2nUBYACi0kRkiCgFNk6d?=
 =?us-ascii?Q?hn7Kzd0RfxMh2XFZI/XrwvlVUM8Jl3fE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0gYQFpJMabLr5V0ldWEpTfOrHiiKCXdkqITirrROkfGA65fp+akMv773UlF+?=
 =?us-ascii?Q?sLhgjx0aVy2vaC3HUK7+6JgnHeAfMHo5VYlgHUtX6+59jpWf0D1pth2x0qi5?=
 =?us-ascii?Q?tL6DU7isryj+/2/iKarai0MJsy8/0iMx0r6eWJU8APqSB0+BBHa3+AVHhk3S?=
 =?us-ascii?Q?mZlPEKHwBHEQjLFD7q/3Cxqk6ZU6lSuGeDzKra2GLlYBBWto2Rcu292BAQ/g?=
 =?us-ascii?Q?yiq0//5XI69tKqlSlPT2DiOWpz2v40I2KsV8rCe/QxtWSZXQBHkh5oCClBia?=
 =?us-ascii?Q?o6gDNK2T4kFL3UyMYe3YExFDpVkvP0g/SUvQ56qt6EpNM4hMDDC3WCAN+rKr?=
 =?us-ascii?Q?sQRf9u7oYz0N97B3Us2Cn3O9Xq3a2Fet73RFDGPX3Opt+WFS5rOotomBtZSC?=
 =?us-ascii?Q?Hbe+QbuafdLMnV2N8HCTv15FcshTJ1phnJgzIaxpmh/kZ+odGb9fmhXnjYkv?=
 =?us-ascii?Q?1X5i63AATgZxvenVETKtRKAuq89vttlK40k7BJqvzynANVV2GdWf3otBFwG0?=
 =?us-ascii?Q?ReMR0ljSoWpi1GL/KAaJ4YWahfMuxe+qpVF1sTAclY6EFOZT/aSwrO/gXTmM?=
 =?us-ascii?Q?426SQQBgXmelMGHMHfkb1xEVWbgldnX417NBhYfYjcFJxSh58JAqlB8fJmYS?=
 =?us-ascii?Q?Sf2/rDh1YW8vG4nmeGgUir5oPWORxVEstgnMNSwZ10Q1xOP3DHnpdKy1j5yD?=
 =?us-ascii?Q?LJgAB0clOZQXeJfUm8J+DGI2mPbt/au4pufyPQcX/bQsmqCb2PZmoG9c2IQc?=
 =?us-ascii?Q?DRJrPW2dWDI5uZpV7OtUvNBF7qMFP5bMux1SQPHh+y9MykAHdEW+QuL1wtrs?=
 =?us-ascii?Q?3Sb+IXSn9F0yGuaZ1BhDHMEWdM8REOYcMItvCGDuNPy5SkzWJHcMQHryeUHk?=
 =?us-ascii?Q?Yvbf5YOkk2Q3FzLU3bEruG+RlouAB/F+yRZ8WgPIrLqDc3q0YFpvrRrrVSpO?=
 =?us-ascii?Q?46zBFDIcIBri5jwksf9znSA8o+iewKQkCYXY37EsElsV9vEumiVzRPMtfHNZ?=
 =?us-ascii?Q?3W3ouzRizwHvojphwb6xntIxH6K1B/1PQacOybm4XIfG2EacvTSuqiQbSDrl?=
 =?us-ascii?Q?l24skimb3kRsEwkHL0R8bBsCyfH8BzzM7e1qyAbC1W87YLFLhSA+/rmAwU+N?=
 =?us-ascii?Q?Y2A2U24okYWEx7V880FEQwL/jDQZGKyaEHAzUgSdVJxi2lennrvx5/C095yP?=
 =?us-ascii?Q?5r5Yh8wHgepGKuVycPIB5R+RbOSS46pXp2lhdub6ifwHXw2YUnabfaU5gPI/?=
 =?us-ascii?Q?O9LdN2H+AaYkTsr5A/owsoetLhRs1YZII1Vl/uIzhUFTAQtZfjVU+2cIxfJi?=
 =?us-ascii?Q?em5Xo56Q2Iaegv6bZ9gEG2522fAxTABHLKTlTRKA8wOtnM+LNO3VSbi3RhG+?=
 =?us-ascii?Q?5oeJyTjAM4XKj8iRtMT+VUtDi88189YWpDOSXShDx1Agc5HGy7O2L3mk1xAm?=
 =?us-ascii?Q?0bu8oeCI4djZ/Y4xwE487odEdeVljUOKkRft3Y5niUc0zDRnsm1CWaBK7LD9?=
 =?us-ascii?Q?UwrWW7+YUuEOm262o21gACLbhRK3f+HVDhH3aSuGXn9KfpZN9TEFZnnsMvz0?=
 =?us-ascii?Q?bZaJ5HdEiJML7SGevRDYXrQlmOFEgfftHkqTxfOrn3khtqeLJKZOehGE8cxi?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GOv7eYpV9rxLHPxLOXCQy546x1qSljdYsJd0SZIkXoju3bBw9wbPfdt9uNnSSNiuLV87e0bbXdRB78ZFASNQ97SENaGwfTjfrF0zFH17SnifXefq513DM9++RhoTEAOYDvuFQClT71E2jW3zTpZyc2SzsNT3U6PUPYbiixa81suVLvI/YcEwAK1qmxjEIvBetCj4XdUs3QBMxkZ8QS1pWzy+oWnL6yVxSXaneyw3qr8uaKQNqTC0wddOrc3GwwMtRsOix3GuCuBDPkHFWm1FLCy3xGEbwRUfsuNCrkFGEyOli41jDZ/HtPQxaDd25NjyYobqX7QHw6eTQHnvTZ+Mjm0CtTWbpGRmc+MBofDSEOBz9oGReGlC08bdmbSdvJ64zs+xO3O2jCd5fFVJbkqyyVRudKpYi0zpQ/SgnIMoU+818tM8IX9XF/0tY4fSBdUhIXfd1HLhFWcW/p+dVBHlJ55MXpNafE2aub6xAdXx/ZXVG6z1duNi0zbU87d4WNSHqovWNdJPHKe6Og8gc+wiozbAs8nnZN/2x9WrVGwmqrNPCmPfQkKPzDKVYPDJrDgPxloW6sfOtkl6WaanKLgkf6yIpCLeIdnrN2gjCEV/EW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e41213-05e0-4996-0bb8-08de27e65995
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:39:03.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gV2wage+WNg9uspQv8ozN85YAPj3rQSll9IfLAxxpC1q+p97qUJ8tOUmaNMh80BFT5ZeOUd5w+QH9Rf4nfCjUpEA0KXthObs7WmiR7I2yIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=782
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511200017
X-Proofpoint-GUID: FSmhpY4LaT7CrmzDl2HsYYFxip--fj04
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691e8d5e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXzM5IT3btwLzq
 X9HT4gX3DeUkpsr/ftll4nzTyiru7fAed1e5QQeZjCqAMHirZLxtLblXhMy54eTLXO8jbfcSKCA
 VnC1ishZ7nKoJtIwiJnBJjXpjcRQAFxDwdPJRZlRHzjXmh1t8HgfglpurexuUqIHwrroTq41jWn
 cY1mec/aSkFtLPtBbx2Jqn2SlIvJh96rpKOqpzHVxEIJSH0taYHNQs4DjTe89+weuil6kjxEcUG
 EzOD6r+IrXIFhI5f2q72D/K5XpNAz2E2dAGRcnP1aBLVeuQNJKiF9misGqXc9OcAr/foH0NBIHe
 XCAsZNBYsB+mtj8iD4FRJzzD6/UGd9S2MpuZPofDxlYP2ZesVQDVtTjzkKe+Sn8NEIcSb+2y0IX
 thZu8wQ5pvSG+anpxI4QhsS1+3av9A==
X-Proofpoint-ORIG-GUID: FSmhpY4LaT7CrmzDl2HsYYFxip--fj04


Zilin,

> In qla2xxx_process_purls_iocb(), an item is allocated via
> qla27xx_copy_multiple_pkt(), which internally calls
> qla24xx_alloc_purex_item().

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
