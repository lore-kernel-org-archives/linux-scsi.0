Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEB81AC88A;
	Fri, 16 Aug 2024 03:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723780578; cv=fail; b=fSEZ7kokOFLPtHB4t0LukEZprMBF4Tu0kHj/C5hDrKloyf/uYOG7tNF5/2jrckfC9sU5KbIWeBn4IzJztcFDemNZLZsgTpMvImddh401ybd4rdJULKikqP38H4XzlSmmzDVXmQeJcIwPvFiutbqqLBq+l/yOmCUqg2M5kHpBh2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723780578; c=relaxed/simple;
	bh=hopNgS4lm1JkzbCkMYH+d5iFAsBoqrj4H2OsTN8r42E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GYarzZHtauZPIw8pmWsce1gRVRCaw4tAK7ti+QZV3yMJglU3ocL8X1EvTl2QqJNg09ARdmEbsjV7ihPETrsWiMP2gKSGaY+J2DXGficzSVrNE36Tg4AJGYDAbt5ApKGU2DMsNhTfyOvMWjEAr42Ozqn7gUdU2eUi9M5HCPH8mko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ya0vpnKD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ol2w5vt4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ya0vpnKD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ol2w5vt4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FLwUos022075;
	Fri, 16 Aug 2024 03:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=HXUst8N91RoJY4
	fjwmrxzJPzo2z8HQkRlaNiOv5W7xk=; b=Ya0vpnKDvfbI63DswANebZggxf2Pd8
	MtLapgQkcnjsQb59G9bILHaLnd2BhsXb4WB0Jtbnw0U5ZZ/9SvVAQ/pzpqTRZxjr
	bDJLK82S0vjGVzA4YdiMSdwRY65Vmc8k3qmuWuj9DyH4jVzmXcV6vibq4SslNbyq
	ZRHbI+VzFDajf4Bcf/VMuOoKnscRh1EbrhBEgt5WbnVDyqC6ULtw4Zd+1Hf8czaX
	zrXA06jXDSnUUze4zwVwDlATvEmHTOi8ea8gZ9x1wiNVkZwj74/bZ2WogpCjllM2
	CcZKFLrnijoYME7mwdOt5uZoU+8EGdnPDPgDmLBO/me+cimEP/gonYTw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttkufw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Aug 2024 03:56:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47G3b2WW003397;
	Fri, 16 Aug 2024 03:56:09 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnbtjsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Aug 2024 03:56:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dT5U5f4pV0ddwV2CXD0JAiEvqvQ2im31G4kuJyEdVmJC7fzUgdDqH7ymwkF0aDrJdigJELP8oUsamudr19XwIT2U405taqQchOCsZuTLnLaSesppiFEqAbEhbEeSZu1AoDrjOKAtQkZ1kFpCqdcJXymuULkXALcKPX9s9iHwAQBy1U8Lw7K+h9va7FQzE5vF84VT71dq1hE5zzuaMjtc9DASn3XNBVI72YgQ4EREWdhVf7elXMhnE3jI6mW4cEZiuy+XmFKUjogS46NARXflGzEyz66pUiFtMgbYjEamliDPniSPqgVJIOR1h2U2Y4+KJb7gB+3/RDyOve4idlU+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXUst8N91RoJY4fjwmrxzJPzo2z8HQkRlaNiOv5W7xk=;
 b=b6bz4qdSen5ih5nbqWOXsa7agqokSPhKHF+xpNrqf4Vi6CVibcTwJsgAA6XV4SElSZRkxvV5+sjsWD23/0uvoKCA/ktFKHqB1geCoO2facT8BcDZCG/TvYa64n1OkXsANzFZoM5Xb2VGxSmVb61XSs/rk/DHNyP6lj8tklGB0C3xGxPVY0HkiHr87tRpzLltUHkVaBw05xM9OnaJiFfIrmjo4k7ouLl7kIFheXNg6o/6aMRV5OrO5G1TYDNBTt854B81IeAVRVZmRko/mvyGqy7pxy86FLLA3abyKXLkegNjWikZ+E20LBmIgnM3h9oXCCpbaYQ+EyEQRlWDphFy9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXUst8N91RoJY4fjwmrxzJPzo2z8HQkRlaNiOv5W7xk=;
 b=Ol2w5vt4kuoDYGVqb9X7xLC1uSZbEAxnehW17EGSdUx5OEHbG5AAZE6LLkkSmlXf8nmhkfFOsbpMXRqaqFLK+xqcBI0QIrAZXnjrAKXPm8q+aPAGdSjOcoGmcLlTRaU1GqdbHjCxj/7xMX20PYBF33hkn74ZFSyFMNyJh3Zmj90=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN0PR10MB5935.namprd10.prod.outlook.com (2603:10b6:208:3cd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.16; Fri, 16 Aug
 2024 03:56:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.009; Fri, 16 Aug 2024
 03:56:05 +0000
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: fengli@smartx.com, hch@lst.de, martin.petersen@oracle.com, axboe@kernel.dk,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] critical target error, bisected
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Zrog4DYXrirhJE7P@debian.local> (Chris Bainbridge's message of
	"Mon, 12 Aug 2024 15:49:04 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
References: <Zrog4DYXrirhJE7P@debian.local>
Date: Thu, 15 Aug 2024 23:56:01 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN0PR10MB5935:EE_
X-MS-Office365-Filtering-Correlation-Id: 55c42787-0f34-48cc-d672-08dcbda75a7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?diLzDkJdoqQBw61/NIITtaQqnJmmcj0uyT9NGSxkvuapHWbCeDgZygyUWywq?=
 =?us-ascii?Q?+8tjZMxPA9s4pd/usUEluWqiL/ZaQQ4TZFlQIuKl/1gpqF/ktlUoyKWoH6vc?=
 =?us-ascii?Q?FYJXG/uVoSXXLsUTfVvXRQdX9ob534p+DIoHh+s/OMf7AOYaIv5hyLWY6LN1?=
 =?us-ascii?Q?xr+9hmIT4nXxtu7u5bKw6EO1uh0ws8O72oEY6C3/HggQlE6Zb/gfGUZCKBte?=
 =?us-ascii?Q?w4uzQvt45sFR84+/NavpGptVBIoqWvNDMxZtzzmptnhLw45kpcsJiL/cFLJm?=
 =?us-ascii?Q?3Tc0xV0J6c75oUTGt4ikkY+Ly3XGixLCsoDNH0M1Fz/suNndXvgKCTF8j1il?=
 =?us-ascii?Q?Unf6+pS76IDrVYrm/xpVrYWf55SUoHTyqnqVAQQvvMkWjnuG8C7/JWzMLbrQ?=
 =?us-ascii?Q?pH1BUUfb4YjAFBKNxjNapEj0zwXGzSXHbh1Jp1hu/FcTibDGNc0lZkkJRnI8?=
 =?us-ascii?Q?QKjYj1OVdolyCbyIAff7WDdkAQOL7lQwehrVl4O22Nd+PzPAgdsRgM8/kIO7?=
 =?us-ascii?Q?tQg4IWQ6Qfn1v16ZPPD3101Bwj67+hLZYJxqdlkE0pB/n5uUM2yT6ctZqpH2?=
 =?us-ascii?Q?M3L0VU1PahWWsIFb4iOh7zjeXqGdt9hec5VvcCXOb9jo4S3f5WfwiILIg68v?=
 =?us-ascii?Q?eDEkLE0Owp6Y1IrsdVvx0yTlyfhTbR3AUFKDKH0plfXGtZEtVWCO2CREQbKN?=
 =?us-ascii?Q?1vdAcI9EKu8KLXax6RODn3dnIwFdvBcEc7sJECSEAvkZzGhuT8LFgAdWbVh+?=
 =?us-ascii?Q?Id2nWWMLdoVPmZnhyA4ifGaYO/EpfqVhpptaQw2/htpH2S1YA9zRsuV7yFKa?=
 =?us-ascii?Q?W0ESwP+eLW+5ow61A3EsXzN58NcPJB3YIZRRV+RoYk52m0xWAy2F1IpeqMSZ?=
 =?us-ascii?Q?2t6CpVvCd+sadb+9oahnaxwgsGOveVqz9EqqubAFYcBDXDgcLr2iUQu71MTD?=
 =?us-ascii?Q?NlPOCSwQgUV5c/rTWsfKfdyt8tQ0H5Ixa2+QPX2lXiPJn/xcz7bxIQjAYFNs?=
 =?us-ascii?Q?UYuuRIdisJTnN0y+y1NNBq0tPsC75FTxdjFPSWeV9a+LXWc3bpe/GHbWzbtb?=
 =?us-ascii?Q?Xj87OPv8CxII3GX63FjBkO5cQX2wFUTB61sPnsuXwvLeeyu2+Z8IWsgqPOZQ?=
 =?us-ascii?Q?5iLqyk7dJnAMBbvK9tS29j1TVXGxmStoQDccJl/lM2W3PXSbIU/UFbFYon9t?=
 =?us-ascii?Q?ye9J65HdGUBm8GNK5ELFWUHXrV0tYXkYf15uB0agdif2kusDuojgzHK3wjkL?=
 =?us-ascii?Q?CyZ6cyc+H2vY9U8HTKUZ0jngezy8FDsMhIV33jSAvh0+NhYEBlOiaFvdDA4T?=
 =?us-ascii?Q?r25lCB7MNn1FWEuE0w9LqtkqCX/DnLmUWQjsSDKQ+weAIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QEvuPFfNzd9qyY5t+bq9de2ztH1z9bUuwxgj/2R9FyRlCeHlnHLUcffDa8m8?=
 =?us-ascii?Q?M35liBZCWIi/WgUUk/V41m/8MUOI4KsqAKUPgnc6JyF3ETm/YTzC6iLnjznd?=
 =?us-ascii?Q?C3bJwtVwQ5+JI4ROI7RH11p1fdEbQ5em7+Vwb5649yBbTNUXaftevnrNgCIG?=
 =?us-ascii?Q?Tye+A3vkBQXU8JylM/5QJ+ton5xsrr+9zJxPstdG99gV5mjiB8aJlE8g7vtq?=
 =?us-ascii?Q?vt2wCl/yJqE5sNdaSPuwshdXv6TwejZE25rbwWy+cuKOcYAt4VeFdqAA15Z7?=
 =?us-ascii?Q?CsiOnMlWuf9sdp6lenKapxs7+PHt41AI522RSlB+xwh5p0I0lCjx6y0lu455?=
 =?us-ascii?Q?D77oJt1GphMH9JEQq2pYAkk1fqUqWDV4jXjGxkIJfQEiZtojiOlX+7Kx8ILb?=
 =?us-ascii?Q?gYYaqpkNOSfP8b4eleLE06ny8kzqe0tmiZEHkqebQ11Nz+msARzcHkUa736s?=
 =?us-ascii?Q?uZglbHHmZaSljo1MAqDG+Aea/KAkM+pxzs2idpGGxcEhCV3m/5vJsIs4cdC2?=
 =?us-ascii?Q?YYyBrK0jnt1+ecG1Qq8orXBtLLflJ3usC6XTicMPyKOphO/3EOkAJxAXzIM4?=
 =?us-ascii?Q?mI832XCbU6c4tHmOrMLC0K/SFO7dtlJbb+L/O6THoubNHaUEkhLbHr1TBQOa?=
 =?us-ascii?Q?hX8Tg0jHp/MnisapdQUx+LX7nxDk724HD2FV9bRphYMYRp9QERSR9eiOZz6p?=
 =?us-ascii?Q?odG9U8tgWpwgnHQScWYYo2VlWBhmEAQzuDIy1Euh9ImHKLKj/v6PimGJv6Rw?=
 =?us-ascii?Q?ojCNLZZVteAu+ndOn+JbLXgsyW8oUfJHnqzIHatta4h4xQoG/+ATM6pt+cAI?=
 =?us-ascii?Q?WLYyN0b8aC/+2CnJj0Xi7mIzggB2j1sgRV4MjpdDtiWdZW4GNdPlyUmX9v++?=
 =?us-ascii?Q?uSzCPd5xc3tE0Yj6Licq8fv6Mg40WAjKmIcxjB6kSDAOhMqus1dkrcWG5opn?=
 =?us-ascii?Q?jHomUTxPiUxiyeelrAvtZoo+t2xskTUfg212o/HePFhDzFkuel9/0ynvlhyz?=
 =?us-ascii?Q?rEH+4dIALpRP7zpeVM7E0AwA7+6sLHU/MIqisrmZqsFBpyskJGuJENpVwhw2?=
 =?us-ascii?Q?zWZYRgSvhOcp5rcgatTk05U1msdcsu5Yft2c4jHDQjKZ8XZhMX/wLaIaKZ9m?=
 =?us-ascii?Q?8j9tMbAlCWCcVVYGxPgrAlq7GEWF6dJk5o36iocvjen1BKlyKVErJ4521B3l?=
 =?us-ascii?Q?LviHYSH9uF9AQhmB//cmauXygA3rAgJznUN9L5KmdyhMExG3qvfQcVwMQ+sP?=
 =?us-ascii?Q?zlIM0Hc+U75lRoN0fgLPcim9Gt3XcT/hI+FGJywNP/L2qhJEAIK2zVy6/fM4?=
 =?us-ascii?Q?r78QOd61aIIU5nbeR8/SyVhGOAos8Y3Rn/SyHuMSi/3UvdAxvKytA/5KafuD?=
 =?us-ascii?Q?MqLLn1IEN1k1ElUySKdhWQo+1oaT/VPxcWMHpIttm52I8zr/49okiaMRdN0C?=
 =?us-ascii?Q?9gFLCMagOHKb2w6R/yvIK6KzCZj6bJ6So2lwjEUROH2Pq2edYkBU4nLWyjwm?=
 =?us-ascii?Q?xbqiyEKpaH+VOU75qCtQEUnyuNEeTTJlIZQWpv4cwI1ssDDgM+jRmRGjxE5g?=
 =?us-ascii?Q?JCwmBD78cNCLKD6L8TyVAqFEnH9urjBQdoR1Ye11yHHLa5CLZu06x3CmwOVP?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dGL8jRSyxcbpAETepkhiCV9EyaGRGNTjFuz7aSUTvrH2gQhEHr2CVuEEkgPfiMwIWNpODHPvjT4fkCmkuy2A65dVDxklKg4mjKZ2MX4+0D0RBLZMcCKM8VB5tz9fmtst035KYUQXwsrRsNrm3mNWOdfQS0S8Fk1UD2d/N+FY+/WUMRCZzSLgTTnhI/t5ikDHddC7FcY4Wvv4SbRN1ilVkpHmvHWNU10egRzdS0ae7Jpc93ZXZ5hab5blShjvBJUsPwQylKeQ4gbBNCC/PXf8GKl0u87rDTS2aJ/fKFdwdNB7jD6td0cqCGOlqCNq5hA82WglS8I7oZFTsFofYS2pHD+aG3dxpUfvgE0Qkvl46/o+L8hXLhibaSbLrGCddFnUEx4P+tucwD/DoOo0A82gnFTXvZ15QVOm8/KgKxfbjC9AOLzmIOW/EOBVmlIlEk42VaFekhlw/MPcPe2Oo9cgc2qY/UkOnO09hPBVHWCU6pLprg5Td+f4/KzqF4YJRtdu0jXAvW3C5Nq9qBlbbjkLQ1R240shVQmuzGgS/sA8t8YccoQqitPgZIXV8EFkibsEG1dUeN/UBiNI7UmX3v8oKKQfsjUmS0het+JheV6Z6Ug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c42787-0f34-48cc-d672-08dcbda75a7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 03:56:05.8234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3b3p3lTqDaGuGVfEYnM8HULJxWP3QZCvUazHcqPnfAdueUGEP/QHRuiK2koXfqCZYn4wGc1k7dGXl0cB8+ZMEMGKUFZ9jPZ6wLMxPk8W7zo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5935
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_18,2024-08-15_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408160026
X-Proofpoint-ORIG-GUID: 2bdiFQeMu-QJ4c7AV0_2PF3Vhlhwwf67
X-Proofpoint-GUID: 2bdiFQeMu-QJ4c7AV0_2PF3Vhlhwwf67


Chris,

> [  195.647081] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> [  195.647093] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
> [  195.647096] sd 0:0:0:0: [sda] tag#0 Add. Sense: Invalid command operation code
> [  195.647099] sd 0:0:0:0: [sda] tag#0 CDB: Write same(16) 93 08 00 00 00 00 04 dd 42 f8 00 00 2d 48 00 00
> [  195.647101] critical target error, dev sda, sector 81609464 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0

I would appreciate if you could test the following patch.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From dcbe0126551fedef94fd8334288e5b2bb6059475 Mon Sep 17 00:00:00 2001
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 13 Aug 2024 03:58:27 -0400
Subject: [PATCH] scsi: sd: Do not attempt to configure discard unless LBPME is
 set

Commit f874d7210d88 ("scsi: sd: Keep the discard mode stable")
attempted to address an issue where one mode of discard operation got
configured prior to the device completing full discovery.
Unfortunately this change assumed discard was always enabled on the
device.

Do not attempt to configure discard unless LBPME is set.

Fixes: f874d7210d88 ("scsi: sd: Keep the discard mode stable")
Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 699f4f9674d9..966fc717d235 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3308,6 +3308,9 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
 {
+	if (!sdkp->lbpme)
+		return SD_LBP_DISABLE;
+
 	if (!sdkp->lbpvpd) {
 		/* LBP VPD page not provided */
 		if (sdkp->max_unmap_blocks)
