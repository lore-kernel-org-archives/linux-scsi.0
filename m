Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EF23B3C06;
	Mon, 23 Mar 2026 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274328; cv=fail; b=mR+Nf1YC+M5832gXa3miCB7Tz1N7wQUHsJbIqV++vA0VQvteohRnA4ouLJZB2g40pu/PpBjjjTnFD8vv+zjHTF5LSPptd0CZVE6w3zUCcR1oUofmZD18bS703wJyYSgPsAEaSGgCXJ6cClckA8DbL7qKgrwPyF3d2dZ/IzvbVOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274328; c=relaxed/simple;
	bh=aXRDR6PisGHJ7gMfC/cgDBddqefwyhnt6zbaC/nalYE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UGxfWhOpoP5ZIPTXjukxR2fcMvXkqZ7VejMjT6G+2vDCAgUuuDy0dnn5pKgcLOr0NQJDm4zw/vZ8Ny9OPInPzhJYpE38BPi3kGbLZLGFMjRpqsS7Xt9eb+NYUwz0UPSvSoRIM8zYEcpnjJssnLOu0cMzoFWddNMyt8Ivxbtx8RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i/fkZs53; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HKNP1IUH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i/fkZs53";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HKNP1IUH"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NDsv0p1769962;
	Mon, 23 Mar 2026 13:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EJr+MTJisKfV3nlnkZQORxE2ZRFgnz3G+uf6CuUFTuo=; b=
	i/fkZs53REvVJ/9gEt+eIP85XdsnW6jMuKM6NYfMfsWeD5wqiJVtgt1ZnOb6ebyB
	Sjchh6GvNsCtxJKeh9tZ5J3LzuUIooEGF9dN7xT1Y+s7OZBoulSjD66jTvLXSGvE
	2nKlbUG9yt665Q3Ky4UlE5g/ZG2mtC96PnJU3jn92/AiI1yBSRL7/KVYuELUAlk9
	ZqgTU4N4DAd2Il8npzmMPkpLXa+vyvWbi4J+4TIzeEIdnaPAbDkpoJaLjhe1v+cY
	uV9y2/VWhc1l55aGrtByC2dluj6dr7YMN9qXHvnG3fSc1gmcZe6//rfBfJ3TowEP
	9GuBXX4Kvx/MJyzhyPI2zA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kj2aa38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:58:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NCgX1h038937;
	Mon, 23 Mar 2026 13:58:30 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8k6f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:58:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk6nzNOVKuWd86kumZ9Y2UMuemKDWbjtwzD5MoklOjxySs/OeCVGXaK5FZUF3DsFuB3FncuT4i6HniFWCYrZKHjxauehl4gO6k23DyJND7oonZZEbYiGdPsCTZ16WT0cm86+aernEyKWD4dsP2ZsVZnSEBqtbJJGQ59aJsN3SwJQcv1yxnrxXI8j22LaxCsQDg5CpG7x7iy1zC/cGX3vbmsd6gkFOMcD7dDvwLYIVgxZX1opg3k1BY+U98zdCrbN0Rt6NpTRaUdPIEfGaAaPB0QFcRDmddDEgKbsYb4NqUfEelz54ld3TN77RmAIAivrbfFM78LD2nAMI9+cF0GSlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJr+MTJisKfV3nlnkZQORxE2ZRFgnz3G+uf6CuUFTuo=;
 b=Uxh4DMeDl/GhGpu5cBs12kgugLQsdkwm1+jgjUMKTcCAQEuZnilFIKorOvRqPzIulRbHSi98+CMG6iTrKEccgavn/CD3oiJKKB4lUWTmXB7ctPRMSjeTNG4LbjTrmp9tE+e9G2tfvGSuDdW/UKYg4X4F0LMC2/xCc7hx+QaJMOX+a+3Y2hGBZxwv7/Av7OJyARdwMd44QOl3rkzZ+QFFOtgHRjWMjrLi5AOZkLuxwWtkOvOf/szxgobs7VslCuggbt5yn4srfxW4XVNFakI3ovTRXOnJoSJhrkM2bARfK0JyljhHfjikxlVvAEatot0bfQvtqBoUUJ36s8RYwBRVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJr+MTJisKfV3nlnkZQORxE2ZRFgnz3G+uf6CuUFTuo=;
 b=HKNP1IUHTcX1Oh1bwUp9XydNSfNHBWiIsMuDN2BRHQ0s+nu13feGOdZo/Og5vvuy3M4C5Lu5MqKV4bm171p6XAZoyBhFccR6M7PLCmzEOVWRQn4zqu4JWWal+dRdsCGDykCM14WV+wVUKNMEIPSbxzVgiZjGkJfrp+cawm51Dwc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH7PR10MB6967.namprd10.prod.outlook.com
 (2603:10b6:510:271::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 13:58:27 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 13:58:26 +0000
Message-ID: <ce741488-9172-405a-b368-c1c56861a936@oracle.com>
Date: Mon, 23 Mar 2026 13:58:22 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] scsi: alua: Add scsi_alua_stpg_run()
To: Hannes Reinecke <hare@suse.com>, Hannes Reinecke <hare@suse.de>,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-8-john.g.garry@oracle.com>
 <1bf4f9c3-7ab9-4be9-9061-0611a41242d3@suse.de>
 <f0625323-655f-49bf-bda8-324c0fa4f520@oracle.com>
 <d149f868-e3ae-4db1-b85b-9d5756d8fa05@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d149f868-e3ae-4db1-b85b-9d5756d8fa05@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH7PR10MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: c5a7c6b3-2cb5-485d-2cbe-08de88e44180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ZSA8arVaUqt1tfSlKkTam41mB1B30JIazhSbvG+VZszPTnAqY+KHns3Xo1MTZOdtPvizJTG8mt2B6sSAdm0w3pyfwbVEPMrXSVRjmTocvPK55lqfc1GxMPd9Z9c02Gu3Dgp2+hoFtMzpii/tc8kqXyV7cZ6TkY68yJ13p92ZdwP2VHlsuiMFj7qHsfe38m+afG0BMMKpAs+OU2Ku4EybBqIv8bXyqLeMV+M+6ATLRA833aWXkr5VYRdzviel2YpmVfR1i8txIQgrj56mM2tUrQx3C+dJ7bAZZfNextMPKRDZOvIueE+HHSHUoiWXTqV5Nt8CZexaFG8XQ8VvlAHvtiUndT9TOynSasTXhrPaDWfuAHAdRZs/rVqjEEGazHgB35hOmgVx8DQZZKkfiSO9utFCpcQFKMmg+UMEgd4EPWbknl/105Po1ewjqBK46Ecx9NgkhDv1Xin3miq2lb5LCfdk80Qir7ZKKsJgu71FkhhjnTvAUQ806gf2TuMqOYDyEBVob5gmoDugtzIbCPmhQuH+VXRsIQuoT9RddOEa+C6rC4Y6iSJvsYkWX8/HdDJi7WIS2B38f3j15JN2hjFrkFIFX2ny5X97loZirJBPL/niPToLAVO1Yj/VQi0YyAJKSwSpk7+8/ZpHux25txyUO/I0ndwTGEBbxLDLoA3fpeSgXc91izYlaSw3JjN9br5UGnpq0h2T3P7qQBEpMC4mUTBAHxomo1PSWqFEBy3utHE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Skt1MUt3Rit5QnkrK1hZcDVlSm1iWThHVnROaWNrWjZzelF2OWFXVXE2T3Rz?=
 =?utf-8?B?VXV4NC92MVlqOHhLZ0w2RGM5VVlIaDJLbi9JcGVyNE1tTW5oTUxyVFpuOGhH?=
 =?utf-8?B?ZXp0MElLbDZ3aXFnWDJLdzZGTnZpQnlpUSswYk5XUWVERkFRNkhMR2xER3VQ?=
 =?utf-8?B?Qit6cE4wU1VoZmpTYjV1WUJyRE9sUGlFcU85V1ozMzNHWjFPSGZrZzRSNWla?=
 =?utf-8?B?TWZNbHpVQkVxTWdlNXY3MTNXenBGc0FXWERUN2tNM0d0b2VIakdiRHJmNzJT?=
 =?utf-8?B?Y3FONWhmVEw5OUF3ZmNhc3d5OW9vOFF4OFBzaURQWURGYksxbmpCZXFOVURl?=
 =?utf-8?B?QVYwM2xtcVNQOFo4S0hReXZXSWdJb0w5aEZMTEFySDVSeHplMHRacVk0dkgr?=
 =?utf-8?B?N3hJa2RpUWJCOXB0WUVFRjMvR2tJZ3lsUlBWVlF3blJndHVybTlZUjBWNEFL?=
 =?utf-8?B?RlJoVkc5eUVQRzE1VDQ1c1daQmZUZlJQL0RCZE9COVozMk14ODBZMkduYmto?=
 =?utf-8?B?emhoZW1oNzZpT3lTd0FUVWFwT0ZzSm8vbCtKcGdDU3VvODFLaXdNbHo0SWE5?=
 =?utf-8?B?WlFpY2FLQ1V4YmY4dWg3UFFna1B0c0twNk83d1paYUoxYkhxTkRpTDRGdnhW?=
 =?utf-8?B?ZnAzUXFSMkRsalJ4ODJQK1pPNXVlOFBvQUVYZ2NFcUtXanQrWTJUenR3SDNB?=
 =?utf-8?B?T0JKRG5oZk5sZjBnUENqaDFlRXVsd3BNUEZwTGs4TStkbFhwcE5oQU9peStM?=
 =?utf-8?B?T1Fka3kxME8wUUtHejFua2R3d1FvZzh0TG9yU3pPZEZONFQ1b0s2VHk5UGRw?=
 =?utf-8?B?RnlMZUJkTmo0c3l3VzcwTGdobmZoTEJQV3p1ZE1yU25tRWowZmsvSmQzdkxM?=
 =?utf-8?B?OUd4WUNWaWdxczJJM0N2Wmw0VXlPQ1M3ZElJdFBNdXRkcmJicWdGWWJ5RTA1?=
 =?utf-8?B?bFVic0h1ME5uS3NWdTh6SWNZZktQWFVveFB4cTdrenhiaUhYY1BQR2k0bGpl?=
 =?utf-8?B?SlNPTTJ5dlkwbWtHNk9MdEFVaHVjemNKUjFFOTJXWWdvMVhKZFZuMUMrWDl2?=
 =?utf-8?B?cU1UalY0b3VCdGVHZVhJWTJZWUl1a1NLUndQYzVYNkYzdXQybW9pV3NvS2dW?=
 =?utf-8?B?MnJ5TjJORjhUWlBaWVRPb0lTeTVBSFpuSnluRkVXd3hoTGFuYUxpbUdOMnpV?=
 =?utf-8?B?Y0xqUnNMb3dOb3AwOHpYdzlvYWRnZkgwTVJ2emI3SEtIajZuY3JnMmRIY2J2?=
 =?utf-8?B?ZzFJZ25zSCtadm5yc1g1QVE4QjF4S0RONjRsVGNsMHNjNnp1YjRHUVI0R1N0?=
 =?utf-8?B?NFQ4TFJVT0JWYUJEbWNGSFNoNm1ZUXQxZnNoajVsU2U0ZkJiQmRpT3RaMzU5?=
 =?utf-8?B?bmZUbHVsVjltUFJMSWtZK2dhN0pTMVU1aWhmVWtmZklHUVAxZ1hDYWx2eFN2?=
 =?utf-8?B?UFp5UWZiY2NGZkZoQ0pkOXpMRjFmT3FTTzZIdkRvNDdWOTR1RnFuY3ZObWVx?=
 =?utf-8?B?Y0NmRjhtNUFxMmJsTUpKTnJ5RkQyMVNUWVdCRkpzTC8wVFpjY01YSDJQcW1k?=
 =?utf-8?B?NEhsYUVIRlo5MGdJRnk5bTZtTGJscWlHMUVralA0c1VYVlVDMEx4VnFla1BU?=
 =?utf-8?B?Y0t2RWFLK0dvcmo5TGc2WVdhZnF3QkRnaHRFVVltZW4yMXBBc1JDby9SU0hy?=
 =?utf-8?B?ZnpJZ1IweUZmb0dGakx6bjJmRjIzdmUwOVAvZmgyOU5xRXZTcStrem1KZ2c3?=
 =?utf-8?B?VHRqQUt1dW0xa3d2eXo5Qnhqc0FmaDNVNnBaY1pKTlpOaVEycm5FLy9Edmwr?=
 =?utf-8?B?bG1LZTlsVUVXVFBNcjJTZ0pMdlowWEpyam1lbUpKNEQ5NmpYM2JjNVdtUzNK?=
 =?utf-8?B?aE1TQ3g4Wks2Zll0dFNGQ1F5SWxwTFprWENZWEl5REFTOU5vU3h6NnhZbVdp?=
 =?utf-8?B?b3VQb0IxbzdoQkJFMXM2Q3ZJdWI0OUhvRGhYM3FHMS9sMmlnRjdCdndRLzlr?=
 =?utf-8?B?Sm9JMUVkVFBuTEo3aDJUYWlxRlJUdUlIS25ZNnlBWFQ5bXdoaVBmcWpzajNY?=
 =?utf-8?B?TVpwVnJ0aUNiakpsdjVNanh1WVFWam4zYWtsUk5ZN1gra3Q3V2dmbEh1UFEy?=
 =?utf-8?B?QmJOKzVmVWg3ZWgrc2MwMzhmektrWkF5QWhHZExnOWRZaENFN2lnQlVUM05h?=
 =?utf-8?B?VlJyRUZ6c0Z6d0h3ODY2cGRyTTdIaFVnYkdMUW1QOWlBL2MzbFBqSmRJL3Qy?=
 =?utf-8?B?SytnV0ZQdWNQOXBlU1VtM3lCam16dFFxa25FcTB1NGdxOU1sZ1FGOExHUkJ1?=
 =?utf-8?B?dzBnaWNTY09YVnVPZGxvSldMSHBIRzFNRGFVdFlHcFlmSStCQnRZSDcrY1RZ?=
 =?utf-8?Q?ZFuL1H5+oT7VgYcg=3D?=
X-Exchange-RoutingPolicyChecked:
	ljsuDXwqJELY9jc8Hnmf1zL0ZMOBwlEySuGzwOvVA9uk1vnQdBX7ww6svPw+l8Tral6fJREVJkgXrLnjze2yhtjN2bLTVGjFKR/xp929t446mCEbbPbfHIoRjWtQk06WF6Hric34h+xgd9wtCytKXOfDg2beN9Gog2hGI8IwLUfePjmrJOse0TwtQHT/Z0fxSO4yreJYPpG6GelgCuEz/jAc19fiFVqfQe2I6gFwuijPNbHrNuXav2pi4V3S9nLwLvcVOynOpECc6XYQreUZl+65AiG/AZCepKa6LIkZA9XDh+1HPV0riBsWz0N9eC0VDnZk0GOu6PmUacNKicaFPg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y/oGJj1fllXuC8Us80NSk3eFtahMFxeCtWqt555mWNLaaHBIDbKhPoHrtcHD8PLyxTZSuO0LUzfdXDiu6thHvJCD6hBla99b5450zR22XbgzBxGd2bmDPSeNGQ17VFZZVEBMmrr8gcfzeoXmqz9k8hiA89E77O6DtA2SBMSiFVXaDMHJzESTKMAs4tvPBLKQ0xv6h823BU3N+LKiIlFCjWKjdmYApN0VBkx+8HGainI5jdbXjNG2CuaYVVDI7GFyFJSe5L7621SUKikMPJFcr5MUMu9auQ3pJGrwKTM81XQkerce2wE+vwSsF1onmkYuHqPSaKlsQ9SHSBhUs33fovdmcIQJId+PfbuJM0oz3V+r86Vgck4f1zsLaDvv1BkBcZO+cZ0PEILtXQambk6lCxJy2He1eg5nwnihVTKJwPnkea5yo67Di93R+CLm/YNw7laEgpr4cdWuQXp7VONaGdFZNp9gnTuVrshY1Uy/vOijkV3Vg8tTUhmG23D614Iaw3aoHXNNfBgicqF9cAO64pBI0bqZeDL6TD0WBQpIM3Bd0fj2wDGd9HSRNskESlk2HqAvUnUo4huCQ7sey/bAEllsVHpjn/TDPQhYjOkZ/dU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a7c6b3-2cb5-485d-2cbe-08de88e44180
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 13:58:26.8391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTRQ+L+OfMw/+i3utQsA5mII03m0zNoDGRcxaxAk+0TI+0l3bQVYgjE0nSdqapwmc5vY694PdqFEUKKUOdkbtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230107
X-Proofpoint-ORIG-GUID: -wwnj_9Dx1NP24k3v3vgCERufafAVf-3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwNyBTYWx0ZWRfXwMOc0IPn09N6
 B46ZoWF5XhLD8grzqfjkF2SaA1GjN1BTlQ9jjOBfOfp7BdrLbEKeVCcJcAipP7wLFRye0lp+3rm
 l4W1XB4m+zVPy9GTlS0YE/ZGIx7a4I/0RQLmax+CkLy6SAeDTwD6/RgYxDgEtN7by4g2FGQpRly
 dWz/6EHqx7d78GhDkeA9EsQ3HLk6myXAUT40dTvYAwMjOfujBUBPQaEqzRxxcY8jWh1CH+5hxip
 K8B78Hly5ynEjHSkif5+7vQUs1biY8p3Q5qujvT6xhmR0C3Gi2P8mP/+dNWoZBJoGvUuJkkdS8e
 33ZJtnQzeRbqJ+S0Difmki/ejHAA/U/nXFM95eA8cWVbfOdvTQeZKu3pQR8unmtfrhmv4mX3KIj
 gzV4zc1hQxMPr8iOvJOsnUhioJ/1UI/t6yzUc5PDfGyhVLQqSs7LZ7/SF/R7A9y22NbPwmixK5i
 WhVNKu6MVWpOD9WZVkOr3VBi8aNE3j0YcRF7RfaY=
X-Proofpoint-GUID: -wwnj_9Dx1NP24k3v3vgCERufafAVf-3
X-Authority-Analysis: v=2.4 cv=KtJAGGWN c=1 sm=1 tr=0 ts=69c14708 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=ESff2PHH_FhU7I1defYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13824

On 18/03/2026 09:24, Hannes Reinecke wrote:
>>
>> It's not so nice to have the functionality spread out. The way I see 
>> it is that drivers/scsi/scsi_alua.c is mostly a library, but also has 
>> functionality to "drive" ALUA for native SCSI multipathing.
>>
>> Anyway, can you confirm which of the following do you think from this 
>> series should be in scsi_dh_alua.c:
>>
>> - scsi_alua_stpg_run()
>> - scsi_alua_stpg()
>> - submit_stpg()
>>
>> You already said scsi_alua_stpg_run() should be.
>>
> Gnaa. Misread that one (blame lack of coffee).
> stpg should be handled in scsi_dh_alua. Arguable
> we could move the utility functions (submit_stpg
> and maybe scsi_alua_stpg) in the core alua code,
> but scsi_alua_stpg_run() should be kept in
> scsi_dh_alua.
> 
> If that makes sense ...

scsi_alua_stpg_run() hardly does anything - scsi_alua_stpg() has the 
bulk of the functionality. I think that it's nicer to co-locate this 
functionality (with the rtpg code), as when we separate we have 
different code read/writing alua_data structure.

However, I have been hearing that SCSI core code only needs implicit 
support, so I can try that (which is keep everything STPG in scsi_dh_alua.c)

Thanks,
John
