Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75748A2BF;
	Wed, 10 Jun 2026 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106406; cv=fail; b=LPeQ2TcGeipx86b5B1oOoLBcG0HyIqu6MMijN0dZxlvAmP6aYG4ZCyrbv0KIPBkw6yAjGxTKHb2sC4zeNA8RCWx68BFwpcpH70YXMY5p6tnnqbAYUvZk5pKlTCXNGZOtLlVvA2DB8EJEZOHrKYCMtXi66RFbxipIZI6LCaAlcpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106406; c=relaxed/simple;
	bh=dzPsRbc//semHCN3FGmWGVJbVWWj4J/6miDSeFhFy1A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZlXKB+H2u49Ik/zGDNFTRsbJ6eXaMu2LC8ZpVQJ5N15NXGHTX2ieMXDqCEaebf4abgJPuHmXlcl12xlA6fJWgRSonvcNXgbraQ+9EL49gVRVWFmx88MSuij4eZrAJaeoaPhsRw7O+y1/JIWPe7tW/ln31eV0Eg6vEJlP8A15L0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D/ZJ4pOT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QuQpctAz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D/ZJ4pOT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QuQpctAz"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ADtm5V1590773;
	Wed, 10 Jun 2026 15:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=h6AS/nxADsyh+RpiFloPOPd6hm+3Z2Uog/5OXzKmy6o=; b=
	D/ZJ4pOTk73sNuSAHEFQLrQ9gZwc+TIKqd8OhrrG1PhFJaMe8S2tOqO0grM3bLF4
	EaHE9mWMTjilpHlEqb8Vr9VIygXk494sE2JxhPt7rHMZDv9rpE70EN9p29bPzS05
	+SG+ltFsmAyIS1dsL68zxJ3ChE9Xqfoa8g0bo6MSNLnfe2FzusXVRpEEUXsuF7S1
	ulUCimarZfUlFv7Bc61sf30XMdlM4IwMqvZ9pzAk1RfBQXVnaJ06lAGd3P42xHwU
	sAlUljUaxfAVNTANJBvcm+GZs4BrRsd5MLaUujUm8wlt+LBPPF0Yc6bLN4Iu9noh
	wJJXcQ9B5sS3IB96lO2ezw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4em9ybevgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 15:46:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65AFh9sq016441;
	Wed, 10 Jun 2026 15:46:36 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eqa8p9mbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 15:46:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xyv47rtcKSFOaLW9eVGmyAYgqqgd2SImOqhktZlYAmV+kLMqdeo45xk0WW38lHgonKbxC4nIb6FBvbk5pWT3P+qmOdYC1Gl1KzD326BXzE1kqoUFBXzmP5L2ToP95qUvK08Jt19Qzd6+mKljcrb6IJ4qlA16wvqxkmHgx5gAxr6KjPLIrUL3WrU/efuxzc61cVJo4w1nRpgqsmB3dGfc+c3pjGd9KbXyq4AiORSzNNJ6BLtBakmtw+ENxMmL/ypnzzfk8Q40i5stx4Lyvq8g6YhvISUGXLrP1uDSDw4VJghPuv22MnqZtRyoLUWvDRVxoZ/54UickSi52eSzx6Drxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6AS/nxADsyh+RpiFloPOPd6hm+3Z2Uog/5OXzKmy6o=;
 b=WIGcHDNqxYGPVjUsJaJW+JlhXEvUtG2JfQc7ZjT0btPpwwK8CniaQO4KsNJ/ok9hA8JcuXgoNmnVgVXBLR5L2zTX+cIEqGyw+Tdx935T2P2Tu8I3MrgMW2pVRXAdIVHIxF89mNIiD6iTlP39E2JYpEF7VYYyxczSRrVGj7PBvHeP4oSYNVmde0Zlx4iqdQz5H+LVROVKaXx91/GnsVnmsajvZQUMvX3DYCrLEuhtOeZgnpTMheLh7p9AwbXp6/Eg+Ltw7/3PXNcJnXEZlxQb2ZnHBWo/NN4xYOP190SR1kXDm5kUwyaJQcfz86xfz6JV3a8MuJc6suVSeZ6V9aeD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6AS/nxADsyh+RpiFloPOPd6hm+3Z2Uog/5OXzKmy6o=;
 b=QuQpctAzU88p8q7syTQ4Y4X5oA7SKUFbpUwIog0nVRafUHkXNj6Y4XWlg/eKX415OwzJUKNu064dNav+Vcmi/acB9NGxVKpouhITLzA0l9qb9PvlrzI0eTbQq89DIjPYFXPUt5mS1TKL5fZdnTyMLru3/OyCQkwDKkrUu+PGyus=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH3PR10MB6810.namprd10.prod.outlook.com
 (2603:10b6:610:140::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 15:46:28 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 15:46:28 +0000
Message-ID: <f5624497-a6e3-45f3-8837-bdf8cf848dfc@oracle.com>
Date: Wed, 10 Jun 2026 16:46:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: Improve style of pnp_device_id array terminator
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0436.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH3PR10MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a98aaf-6c39-4e22-6794-08dec7076f5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|22082099003|18002099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	OwoFiLFqbZylalKyg5hlfU6IFS+FMSAjaXj7NuZ8N8asqbX2wksIKFz7p2KzCrVrL6ULcZKmK1aGCMelJfCNVaNvT/OgHbASAve00EMirAgwVQwbhkvEMUbh+H2I5cl/l6KaBq1RYYc2cnLDSjC9MQ327rFS5MRNV780xuJeTCylcKayaqLg7Y5lirZaVAEqVp7UsyvumSvZcnE//i0jj6ClepGwji1Yqa66hSLwXOqtq+bdPNLqX0LqXp8DwJ+dT9cAjs6TkgWX1A6AtfGtEm+3nuBX16ZwJdN+jtR8+ihVZo0uVsnzelZk0E549Q5WeLHbAl4MI0RibXSeWrm6F11+mucm1v5wC+94dABMSOxE0us1+dXcxgcuT6IlQu0Rhvm4yuIH52cb8zdMWJbVp6iOQ0drd5HhbiA6+B6X6Z2yc211+iPWCRUgDBA77F9nGPUE8CYZekQ2Rc+HbRsvd6ktnIJvcPgIGDP8Qw2tGlFEm8AGNXXZeE3Fq6/DB7gZnQg4EGhl30jd5WcyMZkC0IDwmDZpsZv0YAQxZs2XptRL06THnQV+jsiE1iFQkG8t7qVRDSpQeiIpMQRtoVTNnaYNmQnjFxIEnYvfOuw7zYMMi/3b1wNK9g42ZQEi5s9HxaT43syI7/EzXKkdplcE4j32iRMHn98vxx22m/BvKlUDtaJxMyx9ws2c7p5GsCsw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(22082099003)(18002099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RERFNzdHQWVQdXc2bzZsMHNRRDFuWkRNeEp4L1RVRE0rWmo0ODJLTkRQRDBM?=
 =?utf-8?B?TzJXcWpkUnJEbjA0eFZBUmdKYTNxY1haQVRpWjErQUFqdUU3RVZoUU1Tbzd1?=
 =?utf-8?B?RXdBM0ZvMFdOdDl3Y3JxQkZZWWJ0SW14azFTUDVzVFkxTWdDY3dGL25RcitM?=
 =?utf-8?B?VU5FdGNlREJ4azFBb29qRjluV1VTTUFzZHhZd3BySUthMFdpV1p5QWZyZk1s?=
 =?utf-8?B?c0RGcjllemt3aE1MREE4S0FjVjVvdXllckZ3N0lxZVZ1V2x6bnNMcmZ4eDBl?=
 =?utf-8?B?QUR3bURMcWFxSGV3OWFzSzdGNjRiNlJDaFArTHMvSUNGVzl3OU9ON2tNaVJ5?=
 =?utf-8?B?WHpQd01yYkNzbEswRlNicFY4Wi91NHpyR3pjdDlmZXBhWkZOTC93RDFHRjJO?=
 =?utf-8?B?L2ppSWI1Qnc2dHlDMHVCVjRVM0lwcG81MDdieGppR1MrZXFMcDJJNjJqRnRX?=
 =?utf-8?B?bmVtaDI3eitaOTlQK2tXQUJ6bmhxM0p2Vjh6RFJCckZLSVVvOG9hWFZlbldK?=
 =?utf-8?B?SnJtRmg0U2lKa1FzZjVJZFg2UjNKTUk4dXpNdFpZQVpIQVNRckJoQmZaUkxI?=
 =?utf-8?B?MHhLZ3lrWXNVcGJ0MGhEZzZ2R3EwVEw2MFJrdXhHRnFkNW44YnhTdWM4MXk5?=
 =?utf-8?B?RnEvQ1IzVlJrSnE5eEk2QVNWT3JMQXhYbVExbk43cUdYT09vOVpDTWwrSGFQ?=
 =?utf-8?B?MURuQnhOUjZXQjVMK2d6R2dkOFAwZ1E3RmlGR1dyd0JBL0V2aHI1WGhtN3px?=
 =?utf-8?B?ZDRxSHB5dWd3Z2JLUjkyYVBTM09DNVhaNWo2K254SlFYOFl3a1dXNmwybzRN?=
 =?utf-8?B?bFNTd2JpVUQ5eVRYNS9iOGtSUVNKNjk5VnFOeWMwRG1yU1NXSFpUT3RTZ0Ft?=
 =?utf-8?B?dUxiTzhDamxzSHIyRXhzR3M4YnRTWDAxOGlUNGk3V3RURmx2NVo3bUFhZnFT?=
 =?utf-8?B?cllobnoyemRLSlRCQ05xOGtiZmNZTnpxTWVaOFdueDlEMTlKTlIrVGdFR0Rz?=
 =?utf-8?B?Wi9uY3FHd0tGbUZScEhUMkV3cFZ1UFFRNEVMV3Rod2V6MjR4ekMxU1A2MTAw?=
 =?utf-8?B?clZuVzdFUlpzVk04NzAyaUk0N21HVGd6LzExTmphYURscDJxUS93Q04rSjNp?=
 =?utf-8?B?KzE1UnNjOTd5YWRXK0FlaDFibmVtM2htYjVHYlNibEpBQ09BQjFhUWxrVHRu?=
 =?utf-8?B?OWJqS2tRcTJSTEJKcjQrMHdBSEJBdmtuVXZRQ3lsVU5mVmphenpnTmxVcXVK?=
 =?utf-8?B?N04rcEp4SlNZSllsK3pkamRVN3BTenAwZFg0Ymd4NFBkYUplV05lSlc5N1M4?=
 =?utf-8?B?dzBXTW4zYkhESDRVK0FMUWwyb0FOZXY0elpnUGdSbFdLeS8rVVR2SzF6Wmp5?=
 =?utf-8?B?bnZLVFJMWlNySS9jOS9BWWVJWUMrZ0VGOFhLQWVmTVV3LytLOUR1K1NTZ2c3?=
 =?utf-8?B?ZllLS1NKcXVkZ1pBUFlyQVpCNWRjRFBZWS80anQ1SHdTQmNoRDJHL1FRRlJX?=
 =?utf-8?B?VGVGcU85THFWZEtYMFZMRjlzN25saFFKVzU1Sk9OeVJoZmZrNEJzbnBDNkhn?=
 =?utf-8?B?WXA5dnpaem51OG1FRlFIeEdWcmxXU0twdEE2ajBsRW5VT3JiNlpUZFJQSjdk?=
 =?utf-8?B?U3lBMFZJU3JBQU0vT3N5L0ZwSUtMcHR2UnBlVG9QbGhTKzVzbHdtSWNtWVpT?=
 =?utf-8?B?OVo0TU9RZk5XbTluR1FHbzZzdzdBQm4rSURZeXdhVkRQU2lxU1dONzV1QjMr?=
 =?utf-8?B?bC9aTTBiKzJKM2NrR2EzZXdzaHArZG5oemlBS1FaaGtTK2x4MHluTXFVQzNI?=
 =?utf-8?B?S3RaRjluVnRsN2h4VTM2TC9ZMlE4YnNja1NsbEJoVnVmc2xqdlJubWpoMkJh?=
 =?utf-8?B?Y0oxaWIraWVhbnRRcmFKVXFSMEMzWVcrRlByQzFDTmdFK1JGdHpjREs1RFJj?=
 =?utf-8?B?SzBjSDhUYmZISHJPWWNGSjlOMTFQM3VDWTNTNi9BWkFyN0Uvc1F0RDE4cTlK?=
 =?utf-8?B?eWxpbmVEektnQklFUzhVVVl0TTBhbG4wUlF1anlwcTY2Y0NDdE51NWZIOGFB?=
 =?utf-8?B?SDdzVXpDNGhrdVJCREJVYkgxQWNYWW5Va1dvVVk1SW85TmFLZzdET0Z2TE15?=
 =?utf-8?B?TU1ja0dGYmRUd2lGL2x1MUVCSVVES0dPK0o1T0Vua2xEd1crZElBZHE2Wmdw?=
 =?utf-8?B?VkNpd0Z0c0tRR1dRaXFGSDZpaUc0QzJpTll1dnViVmRZNDJ2R0JHOEhUbU5t?=
 =?utf-8?B?ZzdQeFlqcDFVaStLZHl0MlRUK2wxS1UvVC9Zajd4MUVFcVpvTDdFVmNPYVNv?=
 =?utf-8?B?cHBTcUtlNjFSNDUwTk9QdmJVSDZpME5FK0lRaXBQNjNHM3hBUFQ1c0dSSWFa?=
 =?utf-8?Q?u2hO+l38MZlEWei8=3D?=
X-Exchange-RoutingPolicyChecked:
	a6m99LZUjtuz6EbMB/UV7+7iUPHzUcfw45LQBj4w8u3xSaHxA/jv17I/dC9UwfbkhRb30KU7kTDtyJoHOoKQPFMTj7D27Yhnau3bqLJIQJr9UW82dQ36mF4/Eg+L2dgSEa9WChB7gVZFbFu/Tf0ITV6ZInXkBpXh/Q4C9f9JUrk5QdkQi1nF48zdCuM+mSG/I1UutM9RX/9qTmQYLII7UhBpDX2eKfMQd+f67GVXS1otu8DG8tpmK9PZcmv46QdWvR/N95OJI6jhrS2x71mU8W/w4FXJrAjfV4W4xK4jScrQxhR9E99J/r6xTObQKL0V/prokW828Kf86ywuPei8Gw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nAjhQ6gMf8noBM95vTl95YIqXGHyEwvR8jy9U8zFzES5Ob2t+vKtYfehy0ykzGisFBFc5MOxGG9pVAeBUJGETRRBYEOizJL27YbED/Xli0/zOFo4vFHwMbaDqajvtRZ40DnGmioNnVjfIZ3o9hEoIUPG/0c1b/WgJGY3+8zrHLHINX+W5DTmrvyk4fKmjfMABRnGQgMw/qYYhoicZuCWHZU9qP/vMctMHyyG+peRwUBWUmnpy7GXEXdX+8dQ6/25u4t0VJkamFXVh0D74ktFNbnhvNMMSo2u8Kaddy3BZVZCVPplVLN5Qh6C0MyV7RIlwWs3MsPStr+e5+TCPjHEtsVtMGYdA0GkOuFSkfgKr0sz4yBU0k6FlfYPPJ+JBD9nW37pTqJVafd8JisqWy+0ez5oRh92Xgnarf9qH6mIoHcA44LenkdWUHyfRIdi2lZS66Hu953TJ/tpWMdV30ux0rr4j8+kcP1+KfFnUbIHBWc8bMFSirDKEJZgcYAhXQ1MpIWVwXXkdOVU2X51QiEQprSdxBwIhVpP4dO0Do6xqH4YZL10B8JsDV1KdX7xGiezH5a6kUCu7qVfx0cVotTWGvGONn8PoY/5AsAK5ZCgK4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a98aaf-6c39-4e22-6794-08dec7076f5f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 15:46:28.2040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56ZxB7SLt3H1inpVuKRJ7PVEMEABcKx6Cd5YW00pRzs0p+YQQBkjPO++Onn61jDTVyGPkmCsivybGnghIdyjUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606100149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDE0OSBTYWx0ZWRfX/c5N2FW/lAj3
 n6LJ3+AbksGJzzhpImOS4XVR6BQP2CQJe1cZ3U2y+T3axL9l6P+e5s4eDMUlqRWLkYq38s5vgqU
 tIeBqe9VLgt8nmvC1jTmotYsaVvA832chsndAFLarL78ahgV9dooYn1S/O75qE6Ef6NwWztWCFB
 rEvQ1oH6YTN5ntgv9zWs3INw3NFagbWkMuoPq3vYdcrV6lmvn7H2jUqX5cRtSv/gA5GdSxvCmCs
 cP+fv3AYPHiJyzDLk1SMFvvNEAXV80IjltEgTKHUhoLbt26yNw9OguyGQayol/v7FtBpahCDgcP
 RbaAvsGTPLuUXtBgh98rzSdluX7YjGBrTHxlaZjQeAgc3Hii2luUPPIn9UqAG4YQXAkXwjjXCNs
 ULS6xyVNXefuTaFKhHxFJuD7WepbvWoO+mFwyA0YmSXhVMcXe1iPsu2ta12rUU6ECICIMv1E9ex
 ErXxNaM2bxbWu6x235w==
X-Authority-Analysis: v=2.4 cv=IYK3n2qa c=1 sm=1 tr=0 ts=6a2986df cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=IpJZQVW2AAAA:8
 a=-awlPgXpB2rF18Lt1u4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IawgGOuG5U0WyFbmm1f5:22
X-Proofpoint-GUID: RGeqYKgPkpLZvP9-23KaaRH5Q6FQlPc9
X-Proofpoint-ORIG-GUID: RGeqYKgPkpLZvP9-23KaaRH5Q6FQlPc9

On 10/06/2026 15:36, Uwe Kleine-König (The Capable Hub) wrote:
> To match how device-id array terminators look like for other device
> types drop `.id = ""` from it and let the compiler care for zeroing the
> entry.
> 
> There are no changes in the compiled drivers, only the source looks
> nicer.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
> ---
> Hello,
> 
> I'm currently working on changing various *_device_id definitions.
> This patch is irrelevant for this quest and a pure style update for
> consistency reasons without further dependencies on it. I just stumbled
> over this while working on that quest.
> 
> So if you don't like this patch, I won't insist.
> 
> Best regards
> Uwe
> 
>   drivers/scsi/aha1542.c   | 2 +-
>   drivers/scsi/g_NCR5380.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index fd766282d4a4..93dab19c1cb9 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -1083,7 +1083,7 @@ static int isa_registered;
>   #ifdef CONFIG_PNP
>   static const struct pnp_device_id aha1542_pnp_ids[] = {
>   	{ .id = "ADP1542" },
> -	{ .id = "" }

It seems to be standard practice to use { .id = "" } as pnp dev table 
sentinel - so why change? Are they all going to be changed?

> +	{ }
>   };
>   MODULE_DEVICE_TABLE(pnp, aha1542_pnp_ids);
>   
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 270eae7ac427..41731a7304dd 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -739,7 +739,7 @@ static struct isa_driver generic_NCR5380_isa_driver = {
>   #ifdef CONFIG_PNP
>   static const struct pnp_device_id generic_NCR5380_pnp_ids[] = {
>   	{ .id = "DTC436e", .driver_data = BOARD_DTC3181E },
> -	{ .id = "" }
> +	{ }
>   };
>   MODULE_DEVICE_TABLE(pnp, generic_NCR5380_pnp_ids);
>   
> 
> base-commit: 49e02880ec0a8c378e811bc9d85da188d7c6204c

