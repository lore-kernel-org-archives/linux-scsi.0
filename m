Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FF3258CEC;
	Mon, 14 Jul 2025 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752515598; cv=fail; b=C7jJwEAhpSZZyRiUcojCik8lVuaUXEbIDYUzPO0yIPi2AJLovcIxQUWQW/1z+St+qISxoeixgSVPrR+1DNctILrwjUO/r8svLHR1WJ/93DoOCCylV38EE1QB4U8dyrf+EAUsn+yL3oUZhf2O57CvVmZO1f12vxrhagjgsK4d9/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752515598; c=relaxed/simple;
	bh=1pwK6WXmx2B27bq4UkEbMmsg+tZzln2tAEP38qEUiEc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=R6FutbjPEJ/nbY9rBT9YwsWVtFf8XFlnqYCuDADWdkOmCbF1dUJWy6jhdkzGj+jLLEksSHSDzNhCIgLr+JV+V2sDjwKkl7PwhGtXGYjQJU7HYrunQRuaPRQi2p9rpejRxd01XPYDAvWRI9GNk2btz8hpzxD6wrNRPY0O/5HcpsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l6hm04lg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LzB/D4WL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l6hm04lg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LzB/D4WL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EH3nor001413;
	Mon, 14 Jul 2025 17:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Yh0YSoPdIb1FA2XBm4
	3vyV9NWUNlxIDtBLpLXzPxE98=; b=l6hm04lgCcu6DegI11DSy84vjQ/QuwWtt+
	RQ9qFKVH7m5g38RHSRDcsUUCTjlgxuc9U/ilnQM2glHxi3BQn+/CxetZ9qFRGp4n
	f1BgJM9WtmKHo6vRK+FyBzpfczY6qUvDumj3krTgfEMYIU4PWg9/HF5ePeVripPd
	xgYzBqfwQkJeKCWrMeWMVgnrsTFPe4KaG4GkzdSesNLUojHpSjFm+aDwwspzxhnh
	33SU+FaqiOxZjd2uHSpM1tP2pT/I7GkrvzAwyDoflD795Y1H1olSfihlO43zbh4j
	56kknYZ/SJbEmhl1Fx/j0cV+D7lRhLO5p9kIVJWQ1KKHFv/mtV8Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk8fvtx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:53:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGbjLZ029626;
	Mon, 14 Jul 2025 17:53:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58mj7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:53:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dW+zY6xrgFVWQHS5w18E+HHvffVpqMlZ4snKD6kj0v7in/IQqU1YLcWNKtVF5fWgVl1rG+Gs0RgskEKTWbloKQKSHtNZ6/qWzSW0McvqvNZrP98AD8kg0S0Us11zNgCb1+wC7DqKoAmzduj89Y4oS2hmPdstv9VukVd07OdVPtotkydk3Xe2k2n7Bv+6a//netDSZG0SlzhEovtn+gNtQkW4EgbVwFIuVv4crkdzxxMZ0Gbl/KRXsRZs2R6Qh/ZVtqJFaZfukik5Zdt4loSsjUI5uqjY2iLR5yJ0ggSN/oFs7MbFszCjjM3uGbEQ3DI7vUFWfflGwUK+Dlq/5+eAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yh0YSoPdIb1FA2XBm43vyV9NWUNlxIDtBLpLXzPxE98=;
 b=PNkg0FS2EFIRrmQ322aeFZOrZCNUZIj746w9w+nKUo7U13cQ7QqGtK5f3DUcHYiDVpZbFVjGC8wfX9qAgj2O5XrWiQhk5bFqif2KqQmGC9g3s1H03k0k66S2WgTa66eikFTma4GsRvAMsS6qOm6mi6yDwdSNG6vz7ZcLbs+BSaQfhdTApocsdzsW2S/GmXvAnPY6UvFTKKKGwzGJKl0Wyq+OMQxaTF3IVxbVTqZsv6uPEqS/4iFrY0yWcv1PKxXurJk0jdwOBquoDt3pW6Yqa7GHDxhHhQI4ZB+nMKcwuEKlJaHTpbLi/TMvPvtz4VMNleqz194OVHqNMBFw+x707g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yh0YSoPdIb1FA2XBm43vyV9NWUNlxIDtBLpLXzPxE98=;
 b=LzB/D4WLFeAgqvGL1KE98N5EkVFkr4/qEx4KMmFNadL5UyU/CfbpeyhO1KPScaW6lEHEJVXapolq9q5hxViUPFNsLYFLo9YoPRkT4ScWnl55fMuQIIPEHrftY7UQxnk93+8lVTQX7VQP9cLCAMU5//+0rVemEC0qWDJrHAHXdQg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4435.namprd10.prod.outlook.com (2603:10b6:303:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Mon, 14 Jul
 2025 17:52:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:52:59 +0000
To: Yihang Li <liyihang9@h-partners.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuyonglong@huawei.com>
Subject: Re: [PATCH] scsi: MAINTAINERS: Update hisi_sas entry
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250702012423.1947238-1-liyihang9@h-partners.com> (Yihang Li's
	message of "Wed, 2 Jul 2025 09:24:23 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ms967jj5.fsf@ca-mkp.ca.oracle.com>
References: <20250702012423.1947238-1-liyihang9@h-partners.com>
Date: Mon, 14 Jul 2025 13:52:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: AS4P251CA0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: fd9f7a98-b8ea-4b30-ec4f-08ddc2ff4571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9A70W4aXrhXaL6yDbThH2+L6IAbLu1LJiOHR9/qtut9StBeKZPDd5GsnJNu0?=
 =?us-ascii?Q?IQbn+3UzaP75LL8skL/JDlUQ+ru2eKlAxT3+K5adHCi8pxipAsfCvYCf1IID?=
 =?us-ascii?Q?tvtZ+NBFvcCIGI61OecdTecAxrVAujVenLlp7RKOc95ecDAsy1CyghwwSeUW?=
 =?us-ascii?Q?pd5u4vxh0Vr85aq/gAAJbChJlkVRuvzsIsPlTwzkZNk7Gj0fsHqbEG1oIc3B?=
 =?us-ascii?Q?xX1/KhSZp7MHqaY9pQLttXeOkBQU3aHT9QEXhkiWhY6lNp0bDWA1oY2P3Cto?=
 =?us-ascii?Q?sn9AP2P4+g+2wk7Gkq9FbKGj00QAY4h2F+KdwKhTbmvMd4sxF5TSBeWm6nbl?=
 =?us-ascii?Q?2i5L6HrvBrqnfnZkNlt1H5pmT8kP1+uP4VHB0UHKx9tgL5KIqgBZxIMqGi9g?=
 =?us-ascii?Q?UrRckFSq8ohTnStRObUV70lRfogLD3RwZylrN+TQ1YGczYbdS4HJLl4AtIh+?=
 =?us-ascii?Q?SSVIHhqzpI+Ehude1frJNrAxXJaMtH4ZJpJl49SUARPcT/LcyB/iTE/vXVvc?=
 =?us-ascii?Q?eFl4LuVLB0fK+hT75z3u48A7PT5dBBe5yVZRPwkvx3F19yZZLYrSwfIZr9TB?=
 =?us-ascii?Q?8WvxH6HXprTtt6ozAViJlhDYcepzF7niwBBmKdCObjCn3J5hUPbwcJkV+G+h?=
 =?us-ascii?Q?5UYTDXL4+/ktVQm2O25lVFGTWeumtZSsjUxrDARt9+/VkhvDkLo+CD9/Krus?=
 =?us-ascii?Q?+lUoCNea9wmcUX4HNqHQ+2J1SZETq3cf73oIioFutVM9rwid9I15rojzRWmt?=
 =?us-ascii?Q?bB9tZ0HNMPSX08rWB7g3mLQToSz2gOUyahbBY05nMtnkG5xks5OLz8bbW1PO?=
 =?us-ascii?Q?HufYoI3giEC5F6QlSI2j+KWam8bgf9etKFqlJbz8To/8E2l4xCjm2aG4L7ew?=
 =?us-ascii?Q?x/Pp3oP5+bufyjFimVXfKpgpHc+CMmjaSwwUE1J5RrbEgQwX97/+sgldJVm0?=
 =?us-ascii?Q?ca/rlA86aS4ic2adnB7bfU7jRqAMNsh+Yt8OTlgzx54ZIVi1+U6zB8OnyGGQ?=
 =?us-ascii?Q?Ytay57e5wTDUHaNiLC37tmsmyCjYL7PjJnegiTUrhw6xjMiGrMYgSj6W3YvE?=
 =?us-ascii?Q?Tr7O1nQTCYsu4DzvIZVLq1HKvo0wjwABTW/eYXk8JnO78OJOZyA58ZkZLkWC?=
 =?us-ascii?Q?VqfBOIjHOy0e925AxcyUqdKSjZi9eVqUpheXd6StM7zRK1+Yefv1TxtQWwrO?=
 =?us-ascii?Q?hKLkbSvbP9PEh+e2iU0QJYQNnS1NuAu+76QtizChaAPTzB4D2foTIs4yM3gK?=
 =?us-ascii?Q?o+hxf9c0RBBDLDYRYNDt67qvYWcncAZo8/XcDOeqvLKF7l9tuV0ahnone5qm?=
 =?us-ascii?Q?N2FRSOBK3QvUMFUNTB1A3dHF06qB91rOZRmMidLsZBuohOsN1hQBqY6Ob67U?=
 =?us-ascii?Q?xGRwwvonRpJCJckPrUIC6LWpOT++vKjoLII5KIhdGcW4Ov4ZvWyh/t0yK2Vi?=
 =?us-ascii?Q?73UKzqYZ6+0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z5Pr4a8o9DC24QfGkCtJOkWO6NmIHRaHfVS+lrxcLIkticHmdMd2XGyYBIIu?=
 =?us-ascii?Q?jNwDgQnTi/QdPrjPwqpelD7D6aNNu3lAGutr2mbZDHHy/jJY+9ykWIGmykfU?=
 =?us-ascii?Q?bghFqB1/iQLKrm7RFVD+6kKP7A1AZiHU6NgMXFuSTt2Snx/D6zDajagCr8or?=
 =?us-ascii?Q?gVA4daE+zWTg1yB9gOCmolOpY3qg8BrRXk30WFs8uI6MDKJEp+P9hs6FiD9W?=
 =?us-ascii?Q?JT5w/BSLwekhD0T3Y3Y69YGm+pawC8Ii9Ov4e6ijCF3ZfnadAYEknp7Ubj7T?=
 =?us-ascii?Q?xiitoT+6bYkAI68KW3f0SS5xdHsbMNpPM5c3sVGA0hNDoHxw5HuMiiNdJhLn?=
 =?us-ascii?Q?dcnRooixR+aLeZi2SMbbPdublDL6K1bnvb1OwCUfrWOYmDL3SYuu0FcygD5W?=
 =?us-ascii?Q?a8P2IK7Gjfcl1F9BR2T9Sp0ap7LiB0NMF2oyntaoUZU8N3owIFkU5wbKoOi/?=
 =?us-ascii?Q?IW+U8wUJJozI1Z2scUKOiP9ggZKoYdvxc1VjYWZUFpHl+NL9oeK4aVq8Qtys?=
 =?us-ascii?Q?y0oNZtbws4G662iqXFw+nBJtjb+3tpZ6vzTaUig2HBOhyXMqwwrJefpmbyGO?=
 =?us-ascii?Q?iUyJZ0GNOTbLvH/55UFn5c2WqxC/Fp8CWGzHag9jFodg/dTPk9yw8EboQFE9?=
 =?us-ascii?Q?+fyShGIxstOO/MsW5FcgR6ckwQV7n2baqBwpSIrF71+xm0RrfnAHR0nD2kkD?=
 =?us-ascii?Q?oxHb6+77MnGVEzqQ8mULLiK5Mt2UcZwLY8yZsIdhQPROCsn6t8XeyR46I4VO?=
 =?us-ascii?Q?RQLz4NTiDLzhu9gd+EGRFCDyjY/paXYKYHZG9VNRB1IioUD5MYriIG+vEF3q?=
 =?us-ascii?Q?Yt7go+DBgUMJuYykgI3ic2pY6+zkXb6h1MQDrc2Mn8eGswNJHc5UGfh/GkTS?=
 =?us-ascii?Q?QXBSy7nljBqjUujTfYp5p7roiu4X4nXzchL5iQDJIdxHfZ1O/YXMXW2c+yn6?=
 =?us-ascii?Q?4LoXDcPmH/rMYjBlbUn2yIcndp+f7wZhKjtPSMPlPURMwC7nrd1lBV7OxgQd?=
 =?us-ascii?Q?1vP/NE1q/tYRYttTnSYPBhEf0X2vz/w8CsIQBfXlG/9qfHfJQqYc8hMCMNK6?=
 =?us-ascii?Q?kw5O8G6/6mz7gYhm5kNhfvLS60tMz7nNcRa6yqVRblL5UViRKJN9jxkg5Pfh?=
 =?us-ascii?Q?ot/S3TEkCnZONHl97xEMocHyGo916YG2wgudUTuj+V3PK7SI5suJVVGnnsEP?=
 =?us-ascii?Q?4cwf9xfvzHP9Ur94CiPir8Jvy/KkbbCk3PLwo8+PLbED6D4toTrn3x0KP96Z?=
 =?us-ascii?Q?2E5AvmG6LIXqOetzCxCXorjcoZOXY5STcda2PVnq4u2Zhed8c32AA64AG5pQ?=
 =?us-ascii?Q?2He1QAqEIcauSqeR3TwR94AFdwaNVSUQtUaqy7OA6erQkc3v5j9gunsWMBy1?=
 =?us-ascii?Q?UO2hvoEXOdQwfSThgA+EAoqDW1vaI70osG3RjTjsmkRvIUlg6nrwes5DCPre?=
 =?us-ascii?Q?K7285LkFoWeXv7M7ULsf0/U5FI1Tjlvo9F6fhYD9SEwx5lQ6UbPLl2u5VDry?=
 =?us-ascii?Q?r+2yQGMdIjULJ1cazeyXQd2eeTE+/0eoSfe3eLFg38bQRoWswHdp5fU7194T?=
 =?us-ascii?Q?rZn4pKkSCc7X+Agzx59rl8O1MyNejxnxPfhgWHYlbMalhqFNzUpfm0s7ad4E?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H+QHudZsbWPHqXtELF59lF2KGi5Cw2tOJCPIhutEKcSteVgVPo2KcR3EWSXOfvVX+2uRjOyKI1JBDeyCLuEwIzwLnbPjBSiIE9/7AMIAE0imeKRQMJiyMgloy5gmy2xc6gjzPLrfippHreUfFu5ftRGWHlJFNVKlsEzxh1W84Ot7BqNKVvx/KnqJygLw3yWlAQzu3sgGcGxYqmvE+6CdozlByF1cAfwHAaCnvxChg03Q9o4MflnS2GoR0VLHY88suD96Q+nlieQV+poeiuCIavI0p8/azl3y+LpbtYbQNBIePHjMGYhut4JtR6Zw4GqKRek6APopdKehcUtP56QNMmIF5rueR/UOm2tmsZRvIDsFK6Jb7RsNpb1+m+quTe9nkLRFBfA1xxt0i9VSv7AdI1HT+A7Oe6vm4UgnwOPhplc7ejVyQTgbXSSjh3mRUbHl+cIQGjvvvObelrzSFD0Hj2HizPRL/IKLlrNUwNkRZnNACCE82p06Nak3yGqzCHNkNGyLWGMZDq6v5+dR60Gu2fmdfEUHbB8ClSqEydoI6m5zJk6uyj1xxxFyIna8umVuZW8q+Oli0cY+eaHtj3wdaOnHk3yJP0SjLjS/ClM+5+w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9f7a98-b8ea-4b30-ec4f-08ddc2ff4571
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:52:59.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysmOMykXfeSqXXi22SxJHI+ZAIt+98xdX/TWsLazY+DFfBeGnLeUxgF9CtXUtScQNL7IbOeiDgie5ytyoqu2+6LSmPZfsANC+rVQowr1VXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4435
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_02,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=964 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140113
X-Proofpoint-ORIG-GUID: tmYJPpbWOKo4NaWUmMwrZceVCxw6es2O
X-Authority-Analysis: v=2.4 cv=Of+YDgTY c=1 sm=1 tr=0 ts=687543ff cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=DOGiGVxG8u48VFt_wQcA:9 a=VncyM7JbuJcA:10
X-Proofpoint-GUID: tmYJPpbWOKo4NaWUmMwrZceVCxw6es2O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDExMyBTYWx0ZWRfX831jgy40g3t/ iBBRkK+EA+gwtduXVJTcfZpBLrZwjjuTXUN0G4wv5RQvqQz/2ElX5aDFgVpuYX/4XwyHpGya5ZE FD+FTu/oMgrzaPN3rCO1yRTq64npCQ6r22XUMFOtK+ByMoEM1BfoarD2Ruh0C1fJ5ner5yKYcTm
 3lfiSPv6yW3uZcisW5B6AlE/6EWj2E9P8j6Z/yaupKmGsx7LnAnchAk7b4eZCmLV9FAMDzCh+Sy knAjdc8XIeIpcS1gHXXR2fTMLl/Nb3IbrNN4qA3fJODsT8ntFwvgYXrL1xym9z3rfoMK5R/aCUW Hqyx9A79Oppcgq3QFGDyNSltHijfHN8/MYlfFIKzD/M7deNqS8XoEdC+tOtXhI+Xzxu3cc1ehzK
 QHzcVLQv5Yp0XOIodITQ6PRBq/cYFMhCwW71sknoPSLAUgnmJGAMEZ76r+ahk3n818cEHc9I


Hi Yihang!

> liyihang9@huawei.com no longer works. So update information for hisi_sas.

In situations where affiliation changes it is customary to receive an
acknowledgement from the institution which previously held the
maintainership.

-- 
Martin K. Petersen
