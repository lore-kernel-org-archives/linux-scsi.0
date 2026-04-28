Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F8B3AE18C;
	Tue, 28 Apr 2026 11:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374943; cv=fail; b=O9TOOs9lSXe1/pfQWR49IlY22agSkHnoqmMHiYinN2NdrA1TSg1xSrbeUa0h5YE7IWg+Wu38pDNAeQ5zQjev+PETqYwYanZ+Su6T6Hr9Seqh+oDLTmvznFDREp6qyvZ/r3smvUF0D8ERy2FOWlbC/F4IaQeRv0fTspkAtfW7KeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374943; c=relaxed/simple;
	bh=B29YPJD1f2me7zKlzMB9RhgklRZirRstdmI2njNdhHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oj3QVoZiQIM/ncJQ4/YipgOrakHP77GaNUZTG25HmfNOUKFrCfJedBkRbNr4QfV724D5BdTYYIrTsGYFVJwSEiavmdDB6yKDFjO9+rFrrao21oaabjsdN9MD91hA6pP0bcpfLJxRyL+HwxBB8KerCVRz0wxe6eF8o05I4YZEALs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R44NQ/CE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gQQDBrJT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R44NQ/CE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gQQDBrJT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SA7lhB752809;
	Tue, 28 Apr 2026 11:15:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uhS6p9pjqarIntQnvNGKwoOnKZOPpxAneDXDVdFiink=; b=
	R44NQ/CEO5Gb7ZhdvnDl5SOX1kuWqf8Fg96wiZRwELSWB3y8F6g+N8R44JcbjR6g
	qJYCmCu3GY/1ZBzFKmfLCMVZEKCpu49djnADWID0K9XxLkSuhGlGnKX2n6B8N+1d
	d1BXOkm2ViIMl+yvbNQ2rT/iB+DUvY4x2JsLrFXM3EiUxS0rAdx+Umy5GBknHRKV
	JW8oczaH7RLqFjJdBh17JNXm3SYZZYsbsY9J/E3CMKtb8/7pRgj5W80TG44vc2xF
	UcN0D333T17/+PutSMLhPUp+ryBykgLhKvF2v/FRQbUAit+1hZgfj83/oS3R+ZCG
	jS0u8+345ITcJj6KXojpfA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnefexh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjVY030416;
	Tue, 28 Apr 2026 11:15:25 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvjgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKvixhEgv6XIU3QSeokqVnTXAgqD8IO1gCcwqwGDmxmv/LJde5DpzBkDz7LtFNR3+Q+8jpBt1hczNKLvbU97Ea6sBYsMf23FzWewrsPd0lvlqDGBesez3QSMaaZHp52TXy4tcXs85jwJBQZa2jCSX91jUxzAF0jlMOFySKDqwAIHQ8yssJb+gizJEaS/f4mut8kvWGF9Es9dawxzN5PtjAyvmyJ1WBng22ZXSrs3iawzlKlEosjdb8e7IctzILEafnuaRanMOYAn0PAx8/ch8iLpY7jWqpbktVGt1jNcXrOAbuC/Q6qWAYIu87kT3ohhj59CZslosL7Slp8KRckZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhS6p9pjqarIntQnvNGKwoOnKZOPpxAneDXDVdFiink=;
 b=aXazussosPHPM+UT5+cQDwleyMCPY8qsqRfPLA4V5SsBoGZqjuYZKVCN+dAhBMtnLRsUXiTOed/Mjm35itr9pa3rpbmmFS0OWYl7T5X67QJqvT+QgXlYKm2Eua0c/V8VCWgmMP1HCyEuEP3A0TRH/dh6tjWFng0mRvVMFvQmEO6dx5EodebNxJF/xQQyE19GcYkl3+F5ezk4066oJujdCdrsJ55aKtiUmt7wmxUgYV+dE1RbSCQ5Ism66kFaux/aXorzO1eJ3Idg5OPrpR9VmmeNjNnxT3l1+8aPOD0B4R2Tehk9RWQV5k0cocgfNSDv+Soa04cunQ7ypA87rN9U4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhS6p9pjqarIntQnvNGKwoOnKZOPpxAneDXDVdFiink=;
 b=gQQDBrJT631OkJNgTQ3rs36UWVyxQoubsX0eNi2+haQtzjFefvfATWzh5cQ/2WGVoo1nHxMOpQDWsa/4QgkCD5bJg9VVYZIOTxZm1ZmUkQhFF8Q2cbt3+up+JC9G4vM2vEtaBDQLq4j9k3hqyCSCU5NUQ34TlMqatXmAREhRbLI=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:20 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:20 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 09/18] scsi-multipath: add scsi_mpath_get_nr_active()
Date: Tue, 28 Apr 2026 11:14:38 +0000
Message-ID: <20260428111447.1779062-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:610:77::26) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e1d39de-1e6d-4c84-d842-08dea5176edb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Kz3vnWEXNpkxiFfrkFd7QM55cYyfliMZhRuaKA+/29TpNnujJ5aPWPbjjRevEkK/ThcPbftxIGRsxGDKUt3iOaqjyxG+6bj38J7SHy5qMtfvFH0NQQIZEEfvexpc6qjs7GTURJfbIwDhCe7Hansk7mu76Ipj62ymYYad8xr2aNomNoMjTwA/mWNA/jyb6xMf90fo5QthAx6MWPm9BX6XHrYn1iJwiZry6Pt+FSmWC2tamEkp0sngWOfcaOL7zOnCwDTbMIOSvBfArYYF/JIteVwo66dQ7WCj4lfOL2Rj7P/CsgwbFyQmr8LcP0+FcqaA5hHtNg1ZnthXF+9783GY/hFDWYmIm3Lo0mIYodHQBrxtalvWQSqTTpTE3LtdJuHEQObYnPeODrciGvgrtB/HgzuPoMieLVYpvadLfY23z1zkbv7UMDevs7qf8ldFEKBJovWjt56L8gVKi94VtwzcB0wFlH8KI1QUXXAJU/U6UiMIHbPkFsMMmXgWD9PXcyHo6McyXHiFXvoD4+7XlWRzmqlSYqpcm5ajqXACew0GVYkifRWkBQRbfuX2KzZ2m2pHDi5nyrLnBpB+2Jjb1ONJgvCKmkHj8TFFybmEZNYsCOsTeKN90e9kuP+UGWd3eVzku2XvHRhlvNwpNtMMnNl4S7dBnWdbNk8aVNq79104moioZxxmJtAMQd0vJG3A35KDRt+muww4cnfJci3GtRcMMW8FeKhp5nHNqtn7cp8Wm7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wj7B2o1YB9g9Bsutvq4Fl3jYkYYI+2WSAeOhToDliwhzYhCp/zpSZJHzyvdo?=
 =?us-ascii?Q?pSMv5LNzWXcfP4kc5BQ74Qi55WBrQRpujFysvvqjDKiXsTo+MK9rZOLtOCab?=
 =?us-ascii?Q?rqt4DF7OqLJTny9Vh2gulmM9JG2DoYUZbeJ9ctQj53GzgbMmng+dbyZq0NPV?=
 =?us-ascii?Q?E0C5t/4P417z+IDQ8KkziHwBTWuh6gmHPFqJ5BusawdmpB6XVaowh0PlUeqU?=
 =?us-ascii?Q?mXHvKu61zJ7gqmxd4vY91WYNTjtoy2Vd+wdGV24d+Vt6/B3kUQNjBu5rPXPl?=
 =?us-ascii?Q?kLET6leChT39xQSOKpkoKqYcRPYhr/+2a9wwfvXPb5THul0puZydi5/6bhaA?=
 =?us-ascii?Q?BghY1Ttk2qum7JRj3oY0sdiW3LLp0f8XdoDehPpwMVePtsGwQ2f9zkw3pWxv?=
 =?us-ascii?Q?QVZ3cT5qdEJXtp5vMHeolflH/b4hswdZIrPmTwwtil1qp4lOrGDfOb1NRc5T?=
 =?us-ascii?Q?yH/4KIES131oH5ikIx6BzRsgae+IxrVlypRc9yVpYygxvNbMYmGVwlDiooVQ?=
 =?us-ascii?Q?H5BxbL0t79FanhDLaDEsL3LWLmkHijseeNvdAcfkrsxMlg+7HOH4O0RfUyk9?=
 =?us-ascii?Q?COvR7qfn14K3kGjV8aV7xFYOr+pa4SlRHFIF7dIa+WtwmPZFpG5MJaKqIT1W?=
 =?us-ascii?Q?bKm1e8efk0pC77Ev27QuWlGeMLn/s9YmeIqAdYwd2uJhePmoSco93nx6W0xo?=
 =?us-ascii?Q?Q2iaLCa8SD3oZdZ1lQWE+iYsq+vcWVL2XY/h2vyy0teqkrhHZ4AoTOhRJ9cP?=
 =?us-ascii?Q?jGEXIkLouq/mU1V+XgCfBx5exF/YWhiCnFqQ+IMvnGFAAvh0HaXYh1HyD5vJ?=
 =?us-ascii?Q?cOLY+A+wE1IwQyYtCZdaP6iFhk749Ct33f2UPNBnjHIYmQTXuDOuJ32dMdNB?=
 =?us-ascii?Q?JfQN7Ql+CzE606wHw3wcjPIZ8RNXzdqdECVpycEv1nrXoTXy0WMlcM9ODPxk?=
 =?us-ascii?Q?p5UvNmeak49MIGVy9wUTVvKN4aywoNZkYqH3o30b+gZRUDGRSQ21i7/jHVID?=
 =?us-ascii?Q?AJ2K6bWA5VlUmyOt5ir9Yv++76kXn/Gk8Q+i/J35OyQVNlC32W89i7kEUjay?=
 =?us-ascii?Q?F9UImSeM3+lr2UQilvwZyllOdCUoyW57fdXyo7g3Le2eUYntLB5oO0WyjIHQ?=
 =?us-ascii?Q?veNGtfbIBN7vRMyFAuMYXWQLkI1dfh5bKRlCTc2/WvjxhCy8PgBG3EiOqfig?=
 =?us-ascii?Q?smFl8dpE+Z9nctwJdku5IyFmL0+FsQspDld7727J0hYm0Zjh6cIVTtmJTFAr?=
 =?us-ascii?Q?bYKiISkgfZFTvXbrCtniyg34SWDB/M9Vc4IDCoCUJeLiAaRhFGQfW5VHJJfz?=
 =?us-ascii?Q?brBMUHpMZ8MYT7v/tI9y0uxqWVKlCSbDZHAlt0UpqHapTtfOlDpPORl7Sstb?=
 =?us-ascii?Q?ybY1ZiZcVsbTsFKudQejGgVcNWZWuyc9MDm1EwT9ziJZ/hiVuknhS1Xz4o3F?=
 =?us-ascii?Q?JMZzeYgRj53Vrtx25EtNLzZpi71xQ8SLSB58+gmR+u7rQeYDDnDx7L8Q/XT9?=
 =?us-ascii?Q?n9emNmv0+1UqS6rZxD68V2AMBb4CFwatxFwYvlZ56U5UnDOV0tujpDxXnQCr?=
 =?us-ascii?Q?bY0dQC+3QYcUv4pP+Nvn751L8VREW+B2s0zMzkQzu6+mnRBTWTqzjxQwBR2A?=
 =?us-ascii?Q?sX4iOKiAih3+v1eEGam7b6+VYoeiXNrqa9641cIXKJAmYyMCsomVDaX4XG7B?=
 =?us-ascii?Q?KrGRPkf7PxHG0oRb3flvNfljLeBgkfE+nGkqI0TJyqLMPL9/JJH/LoIRrAOO?=
 =?us-ascii?Q?i8nA2prFMzXw2khdmpuI5g76AmILAkc=3D?=
X-Exchange-RoutingPolicyChecked:
	S+Vsh/CTubVJLsUuRNNJlVzbIJRJ0H8pgrvXRcTjh1SBQzmLl7z0UXb5aznLT78LfXxQm3ieMF9RAuLgWI6TppmlVSCqkHk3/MhyOIcsr7rqjDHOa7phCP7QQqse9ac2NHWF2UGjZ6MssZVXS7iHE/rUHYjpPOjS1Srea/1hP0e5VMgRCghyxFtZin4zMlMrb/6LLjdrsRxIgzLH9XUIiZrAB9tg6dNHQOBl5ovOIJ3EkmVFWQr3QRLTOsX2ppVJoGQXicKgvsVa9yn6FTT9Qv9FL/n3XG/sDzbJltL4RAShRK1f5Vt/K4ilJXDlNQio9GQU70AEEpRDNvgoz0+c1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T/wJQfaE4wbjARM/N0bWeRS8g9rZux4y3i37GTYzscAmgM+JRpjz2++QQeHEsmGJvguMviuoeZo4BRtd2+RDNtpUX+7HRFnpYA9IDZsTpQSom1lI9CT5U8kEQzPnrwLmTiGnxedjLUaAvfAQ7V32DVtTIhnSR36yK/C6BQZrer7mtwyUc4pfU8Z+iIc41mzOi84Vkk9piVplbKgjMUpMdUWghyfP+cxof9vY0uvdPUi/5oeCWdw7i9l/6hwPAbmYA51vA0312TCYPfJJ48Cbehcw/gKWmOHYd3KDjZUuPhNMYLQMezAVj4qdmz2lFi61Z+1pmdqWvOlS62wHch8pGTE5dYWzUKI2iFds8OjxVfgcDGgXGu5BQ9UTNiz8U3XZybGf9+SmHdwoJZ2pqCGlEBaGX+T6auRst9av3/eT7mGLDMpB/mECruUq6lB0awrZSRu1h38XomsoP8PnwlrDV6C1Ckj6T9fyCpiYYKuB4C9f3RQqI6dewcShyxg7yfiiRfoV/DU9JXbGlu6+WAWGoUYIryrbErtoD4wDVfslwvgslVOuexWOrFbynkZQQFUn56dEK3X0RQs1JhOi8/2fUkYkj6ewQRJkWahEhdwZjFE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1d39de-1e6d-4c84-d842-08dea5176edb
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:20.0068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zbbvv8yaiOku/23RMaBehh37jXBod9sF0sqqWNQB+9kKVS01Ohz9dopZvwQ1hANZmgaTh1mLFstDpTzrcpHDTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: UwVhst1VDRMapl1GEFHqvqPDAtlWHfLE
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f096cd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=S0-NFRiyq58gb8qD-mcA:9 cc=ntf
 awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXxkppfXdM3PLp
 KJSsJPPZ1aVyZTff8lC8WX7TP2yHEgPcPrUyakkypSNF8t0GVDyarVNz+UrvTmQkFD3lsiFRr78
 /Sq11hbRy+UP10DJh1Tm0aOlQJn22sFx+K+fl6A73gC/ztfoMIIFdjC5bo+5fb4P5oDR8vLMQXc
 r0gjiyhipqmArBi0UVO+HZB4Q/OwalCGCNJjH0h8dlsYNiTKibrAByfYBgx7CjlcdWy1Nj0hzZx
 rXR/oCo6Rb6V88qGgRSIlYXSCGSrOz0GgWmFIyme4jesVlsG76Z4wlzReCtQbHxNA8Ss3V8g5Mq
 6g46vlGeUTxRz054t95NZ09TtBcanWPOdBJ2Vx7NxEJVBvuotRrzUeHlnKr0DyuulVgXPZu9HRd
 bv/xyPHvmvZFgsgEakaMrxLpqtX0TNJo4M5sBkQ8wc9R2pix5vec0aDd0yEPRCsq64XtHTR8INg
 PixEqnbRWN4j8MDfadQNpM1zXLV/szuFv70NVUeA=
X-Proofpoint-ORIG-GUID: UwVhst1VDRMapl1GEFHqvqPDAtlWHfLE

Add scsi_mpath_get_nr_active() for calculating the number of active
requests associated with an mpath_device. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 11 +++++++++++
 include/scsi/scsi_host.h      |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index a3bf95e2a18eb..80f32b940339f 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -351,12 +351,23 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
 	return false;
 }
 
+static int scsi_mpath_get_nr_active(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	struct Scsi_Host *shost = sdev->host;
+
+	return atomic_read(&shost->mpath_nr_active);
+}
+
 struct mpath_head_template smpdt = {
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
 	.get_iopolicy = scsi_mpath_get_iopolicy,
 	.clone_bio = scsi_mpath_clone_bio,
+	.get_nr_active = scsi_mpath_get_nr_active,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6e12565a81de..979d1e89f0f13 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -752,6 +752,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
-- 
2.43.5

