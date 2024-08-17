Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1CA65C;
	Sat, 17 Aug 2024 00:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723855913; cv=fail; b=bFyOkJLYibUxGRye1th1yWpMf/LIwXpGefrzTsPjbPtCBs0TvcTgZ+KWdu/8TF0EClrBopkkYxYWpcLlOcaQOl4tpjcvtt6Siv5QPIFhek4t59pFZ89Tf3ZfLthoQa2N7IHuPvzk0iblEbdpVIyXtw0iYQamtA37OkgYhP7oImQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723855913; c=relaxed/simple;
	bh=C1GO3nW/aTL9DcS68+kM+sRtgY1UEjH+yUscKHjjqCI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qykhhQ6gdcEg0GTG1yd9BIjXD4TLOgx6we5cEisZVT81xkCBHQNO/PH7HK9BlfrTjEZPdelHQxli1lkhc+oWtDYtck6PHSDGCzd1kSLZd5cF6iVRUscNEfg/FDt5ShNcqFofWcBz8azCRQc1LEK1bBs1MOXXP23oE3uRqbdjY5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fKchJBoU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uPppyNLP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fKchJBoU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uPppyNLP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLCKad027474;
	Sat, 17 Aug 2024 00:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=WRm75vMVbxZMLW
	NylekfaXFsk+btuJMKRfu7zC+MLPo=; b=fKchJBoUlL/WGpW1lE+r6RAI6RJu6E
	g2IbB1P6o9gP1w4HYVcIhIZa8qqdLNtLe7qsmmzn+BkPvJotIGzMMK9lx+0YTkrS
	FQYGoZKMQUZ+Dgi6fO3W9aMNmW7YqU/HiBQZYZZmpiTjlpkyQgOv8nS013dj8cCZ
	PUTMSC0tCCQZIUNo2eva9VqWzANQG6SFf9ATC3pSORkhIxE/RLXRsOxpZlpWI2Vj
	C53NnnALjSrBuGdNEtUdQI9oNjUTE8HnXJ24IHga3oZI/IftOioWNawYILgsidZL
	I6xca93WlbPhqM+7k7vZ0gh8BShCR6xU2dVf3uLPVAop651lzFCxN/Pw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttntpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 00:51:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47GLorqC021101;
	Sat, 17 Aug 2024 00:51:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnkgkgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 00:51:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlUjQrytPFfidL3uwpIkFDehuYuPaVwOPvKcWhr4MqkU3nF3ry815LGg+DW5YjxZSMnePj87wwJ27bk7RwEE8BQq4hGPT2BDFTWOY3c3KLAjEuUulQWhig3baO2T+WfYHox2OP+P3Os9plT3BoZkMRvdm7z1gNq/S5doXAzJC+vaLRsCZkqSKN4/cT7ZVBaymF6aW/KGwJpHCK/AeYNbjZP2rpBUXQnBN61QeA3cnN1yBY0qjLPE1/kMtlrsGpJ5zpUrc/WKrvA3mD09Jg+CSXMBIXHSxgqyB52Ke97aY/ECzURDpHoXtnLOv9k5w0c6O5HETiVx6HBKvXr/ISawKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRm75vMVbxZMLWNylekfaXFsk+btuJMKRfu7zC+MLPo=;
 b=jp2/WN2HMHzoLdwNYJHL8EftMV9RcNMKcfAH6MPsDa+KR+CMoUFVRQNetFDN3wcquD7cxJOlwjsnD5AepwdAoHijubAD5/z0CxvxqQB56XOA2Uepp8PoJn2fWvi5VyII/YibJGdXaIqbR/r0hHIeMhx/hkSGxw2XpeMb9m8+cv3yYWW6cvPNQAdAX+e6OSe/NnDDxT5D9o7weaUc+KtNZCLLhoQbf3z+RPasj7ImnQs3L9r82tWwm76Q+JyXD4pJ8NEAqEFthBvGcpVuynckFizFIBCJSUJ//iWs+IGVBmbhkMwZISf38fWKDzn5zAcCdq0/mWWAHTvmoAV/bsMRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRm75vMVbxZMLWNylekfaXFsk+btuJMKRfu7zC+MLPo=;
 b=uPppyNLPRd2Crpto2lbvZxzgyiUxOcdYKt6+dGAHi6kPjj1haevz7jgx9HIZtoLO4UCbMgDa5W70gHSMolZvMCyHVe27LGfRkFJUA49aYZDgd4RN9QZQv8MaF82ymfV4D1Rexu0qLsxR1Mqs3fSEIlflmkAyo58BdHd2xKy9DwI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7084.namprd10.prod.outlook.com (2603:10b6:a03:4c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Sat, 17 Aug
 2024 00:51:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.009; Sat, 17 Aug 2024
 00:51:38 +0000
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Bainbridge
 <chris.bainbridge@gmail.com>,
        "fengli@smartx.com" <fengli@smartx.com>, hch <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] critical target error, bisected
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <whnt3t5fqae5pujt6fkg5xu6mqxc2x5llbmq6q2lclfuuafbqx@tzj3dzgb7ury>
	(Shinichiro Kawasaki's message of "Fri, 16 Aug 2024 07:59:52 +0000")
Organization: Oracle Corporation
Message-ID: <yq1plq8otwh.fsf@ca-mkp.ca.oracle.com>
References: <Zrog4DYXrirhJE7P@debian.local>
	<yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
	<whnt3t5fqae5pujt6fkg5xu6mqxc2x5llbmq6q2lclfuuafbqx@tzj3dzgb7ury>
Date: Fri, 16 Aug 2024 20:51:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:208:23e::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7084:EE_
X-MS-Office365-Filtering-Correlation-Id: 200199bf-c80c-4ca4-89c3-08dcbe56c03e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L585UA3DcEh+/VKyxGWgI51JJc9uuzYyFs6124i14NsYJwRpKvyHV6vrjhH9?=
 =?us-ascii?Q?T6A4OJgbMJMd7mFmQFbktbFolfcQfKVSJ8TdwslJnz63yz8edXjCVI8/miM4?=
 =?us-ascii?Q?o7LRtHAEIY5LK83oZgqwK43sm2QEvzksuuLmXU5h+hrvbKKdwmr2ttpSRnFW?=
 =?us-ascii?Q?yyVRBYfUyWGr8hIugjVd6844Kmgn0Y4/iJshkrh+XdoCa8jIiB5h88htLYuq?=
 =?us-ascii?Q?7BQQk7hT4mDnsqrttN9wzqrk/aig8TwT7Is4o/rvKO6nihZBifmry52C9oj6?=
 =?us-ascii?Q?elFsDQOHwjvWV2OjFltueBR4BPK/XAXjPRUbut+tPf7+6tadQQbWSGsi8wNo?=
 =?us-ascii?Q?CUs1K8RBfKxf3qvaoS9jQIaM8aX7mL/EDrRQA4AakZsC30sdZ/3dVx+BwBjM?=
 =?us-ascii?Q?fm757HEaqhpn2Y7WyKzsk3ekJ/wW2KKYFj+TZFrbYx6LCTpvZFvgW408d2mn?=
 =?us-ascii?Q?TcoggV8s8u3mlANYzFAKbC5FLxWVhjLrzH0F/XGnLSA/SFh+8u6OD75sv60G?=
 =?us-ascii?Q?ubYLsPvfYqcpN6jp1/7fvF6kiSqz+CjuB37gveO4hfxg9A2rmGUF0J8ZEHii?=
 =?us-ascii?Q?dTWzyo5zCFOUHqzK5CBBMQeHbIJ0JYw1I1sQ0aFAcl5+gEpGathaNGEaLl09?=
 =?us-ascii?Q?jjMZZoPUxYZQBgTuzSaKIqtX15NC9FLxa06zFEUaGWJQ7EZTLKyQg7gbi7vU?=
 =?us-ascii?Q?iyzvqW+nCn7S95nm2JIUDdWSGVSduULQTQH6oXf+er/vn63tDZjKXRS19gRF?=
 =?us-ascii?Q?bzER75P6Vj5bP9vJ42M+3ifA9EWd9J4Sy9o4R2ox7UD/bcIn3+/+FZcRWlyX?=
 =?us-ascii?Q?vKJn7aJpWOKyKOBm6tgaIcEU5x8ZEWFQE9JSjDuDJMgosTw1Ck3slRvbm4uT?=
 =?us-ascii?Q?BgYu2MaZiluJjVGX2R++4HZsPRIwDIfaX2JIwFt566sN6+ltRtPBY5UPCb2i?=
 =?us-ascii?Q?8yVoPD6hh3DsbsOq2g63Fxmu0u0XVWW2KslCdYuaxCoCoQagQcB3Xy2FW3u8?=
 =?us-ascii?Q?UfMdU0qKEDTwxNxpygT+kVVYpQzbtcyE/0AeKWwjTQhYHGIUGY7HSG0QxQgU?=
 =?us-ascii?Q?qdbxvFqHhMLDn3BsWHPVN+JClmWHZiDVsY9zYqQp996MRDJY2vZ3dBPMs7RR?=
 =?us-ascii?Q?vg0R9py2ZqZQ2v1klfnFzyMlkrHs3zYzQ4WnJBH7Cl1QzGxIT8UkSpvekFc7?=
 =?us-ascii?Q?vn3XlNBSwFJCLJbeVcbs9TlxQMnUund6B8fh5EAITenwWdbNAcqm/i0rxz8c?=
 =?us-ascii?Q?2JuLeu3CLC4xF82WoH7KBARrYISxzL0m+nB4VljxE2RDJo8+RJ287zbKZ324?=
 =?us-ascii?Q?3qjT/Yt3znDQEJjh5DqApMt/yq6CGA/fad4L0WrceGNbZw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sDRrj3LAYgoPO8Fz8EC5CmvBEeVBxYYHro0P7BgWcyjOzYNLgEb9v5k5+Q8k?=
 =?us-ascii?Q?zoOw4xBx8CnMuTPYhF6Z/feoQflYpvEYOogiqVwJCWd3Nu+7YCVhPlw69cfQ?=
 =?us-ascii?Q?8QIqlWGGlr7yEcF76Ukk/4a9KpwJJxMr10R/Q4wgPufjKNQFokWfkIBErN5B?=
 =?us-ascii?Q?wjyOuOZZ9XJ4nZpn1MDogyJxMkSg+OvNgCNXCkuoTHxmQMN6XSItFqX9NfxA?=
 =?us-ascii?Q?wyZ7BKRr5D0ZZJvBUseQutZmE/6Na/7jFuXWaZCeh/Usie65WsCVzyJuuwT+?=
 =?us-ascii?Q?O2/t5OMMqbHj723+Y+NDvEpFFiBxZCs48BhrZDeJwsUA14GQBnmJJQIMNnCi?=
 =?us-ascii?Q?gepJTNhh2/NwMaWvv5DInB8Yqw4T8nmg68qjkkJ2ZfFRETpoyqL/o2pwrY9i?=
 =?us-ascii?Q?XgyWRF5A5tjdgxS5j3Is2utGIuYjR8ZF+lXOKlGthNR+B6IVJeqoFn4OW0yL?=
 =?us-ascii?Q?iu5AnHMTFFgM1G9afwD+XSgoa2hJrl8Rd/7RQLgNSuyzOp+cjCmza61hA/73?=
 =?us-ascii?Q?TBW6DF5cE/xtnro3/LyvuOZppyrrtX7TwfzVgv3mAH/lzyPsh8spNz4B0536?=
 =?us-ascii?Q?ebzUc+vwByniKt8eCov6zIAiJDewMctFCAlBGfc5X7nZKUiGP8Sd2q4w1R+9?=
 =?us-ascii?Q?ivt8uvfsgjt+h40UdT/T0pz3VEL9qSkyyWMHjpToMbk9FZjFxZSiYxgOYGzF?=
 =?us-ascii?Q?oeOAWOoWe/g15NDoUe/UxIDPYQZ8w/oVuuHoqHV1u4dph13B4ad1v0H3cRIU?=
 =?us-ascii?Q?XyaVIxzp4LrXyf2dPR/IljfMQLIZ7yugI6rRkV+K+f6jy3TNsGrYf+fojcG5?=
 =?us-ascii?Q?AcBDs9m+DEwZWcDXNVM9pk6LyF7im9GPX4GjBwjWNG6wZEUVGt0UFPMfXTbz?=
 =?us-ascii?Q?P3IFy43Qi/OjYavd+kVRHSiVwRlszSD9GlRs1B5H00VigS+1tPkuMTDIeBJw?=
 =?us-ascii?Q?ag3gFht4Bbgr0LNd/cvK7MAA65VjLmGieM07i5cSunTL3ENHrB+Hy3RmCxep?=
 =?us-ascii?Q?6adn2MC5qPCHLY9DO26TjmyBVNkzKK5TQqhDVz1Lw1LfI90sJuZv6xsMpeTl?=
 =?us-ascii?Q?ymBC3JYRmdJg8h5ZTxdvAOiQ65btU/4qza3/WO1fuLO/DwHupzFP17jVXiM7?=
 =?us-ascii?Q?v+bvHHd/NhkMuW44F1k1qxQz6C7qBBhLABoLceLNe+fkwb5GfqMZTLgjy+bI?=
 =?us-ascii?Q?LNQHWUZybxvq/eYg4BjOwE+kfbd/VPmEtn1fGcvZBW86gaXMJxo8Q4PmZVAh?=
 =?us-ascii?Q?pUNM1+VT+BCGm+ZiZAidfUURQnNqktGjSccwGmLc34Ya9CXD3Sx8mBaH9iA9?=
 =?us-ascii?Q?2LFQ6ok8lSTuWq0/Q0WXLfg+kC2iMO7tGvFPMR+k9dxJbnugIhbKe5yfqnvz?=
 =?us-ascii?Q?xcHbME2txP23MZmqvA7zSgD9toi+JgPd+Mh8zjt4LZ8J4tTZ9ZSaP8WIQZEB?=
 =?us-ascii?Q?XrYybSWw7Fn82KjJH8noKYWCpRRAx57E51/lelrlX5I+MwD2/LTw/1yUQo8Z?=
 =?us-ascii?Q?eEBdcK2moJ9kDvvuahc0mA9sKDtkSLP7Jub/Tf0tXrC7by12uO7pAJf9KIO8?=
 =?us-ascii?Q?w2XdlAQ+Sorp14NclUgtyuCa58b0K9ZWlbzuZRrBxUWxBL7y7rJ1LRHsyaXj?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8NwC4tGW5wNMfBiaHnwrnrfnigFuIGBtrXHQS7UAtdmBdjKfke2kWtrBMacjLsH+gjkWJzpv8eGSNT/ps2Q+NdX4fvR9xs/b7RjPRS38XvaFxKoiyO+AZRNWSIeT07P7X3kdqt+5QQqKxEsHAN3Uk4G3bKBzsSzNRTH2RWFGRqBM4WXG6xDKRMBUS47jj6k0wGtxa5N/mag1KxtH7YTZB9+i3GI9tTHJTcC4M7zun3j92lQb64cluhE/cqmIz5siLNbwWRoRjz5UXu94/YX3cwWgrS9PcfH0AilEz6PZsj8P7i+YCc7pQmMbRrGX1Q8M/vg4AsUnBls7F+gDeWQhEfAbEo3hAH6sl/NZBlsONJKoegN1v50/QMLni0gkGWH+NhPdGu69SBUWNo+rlJ1ZMsK0EQ0GsPi2G4uKGT2F9gCexe5/y09JqFnArcMyseKLiYu9OAxk5C/IUoEwYppX4L3sQNhtJfkRFvxid+wQOSBOHEiXzirk1OcaNZu5T564jWLGYFJAhGHgo06YVsSlRviJZRrbcDIZ/z293wLj62Lu2QBWATWicT9+LQcY1ItbGpsVYHIDWN6sskgJUmpBPcGBxJPq6qNWaioY0DLdrzo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200199bf-c80c-4ca4-89c3-08dcbe56c03e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 00:51:38.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iS8JR5aXePbaJbeJxLCi8lIB0iZIMw1NmypRsZ67H3VeGszsr0KWzXSGZ14yvxYjw/zjPCOCt3PR+uUFpVbZ6bHSFNJnribk79UOfJBUg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7084
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_17,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=419
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170004
X-Proofpoint-ORIG-GUID: sjmof43CS0FubQPufNTda-SSJfUgf7vz
X-Proofpoint-GUID: sjmof43CS0FubQPufNTda-SSJfUgf7vz


Shinichiro,

> I guess SD_LBP_FULL would be more appropriate than SD_LBP_DISABLE,
> because the comment in drivers/scsi/sd.h says that SD_LBP_DISABLE
> indicates that "Discard disabled due to failed cmd".

> I confirmed that the fix patch avoids my failure both with
> SD_LBP_DISABLE and SD_LBP_FULL.

Yes, you are right. It is more appropriate to print "full" in sysfs when
LBMPE is disabled. Printing aside, the two modes are identical. I
switched the return to SDP_LBP_FULL.

-- 
Martin K. Petersen	Oracle Linux Engineering
