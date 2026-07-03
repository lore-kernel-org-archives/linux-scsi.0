Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2B53C3786;
	Fri,  3 Jul 2026 10:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074804; cv=fail; b=DnxeSgaCOlAvBzhaojLlbzfzBB89ALXVYQVIem7ubhNsKi10C/T+eU7AvInCl/rUPrzIAGAe7fEv/yCCd32iao3nVO+x5X8CNNwSEnyAXqnVmuGhs5uS98aq2yAeO2Bk0ewNyLIn+6YzUzzdOamZt3zia4Olfo3S0w2S2F0jGAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074804; c=relaxed/simple;
	bh=Y2MRXNqUrnpu3cBKlG6HsM/bNmwe1UQOSrfptyBSFic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rleC5KCANhAYk0enXJKLkny9rOd5q3GK74ArWSx5Arg5qgwTE4gfxyM83V0SB99lt/FUaBrw2RKsWWJG5u090xvJgRSl2JIrO+pi0A/WHtKlaFiaj6nJJtAQTl8ocBtijD2sm4g8tPDtgd6vzsHvq3jDWjG8FVja0l9I7Pzk3GE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qnd+pbf5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D7hpPJoP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qnd+pbf5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D7hpPJoP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638thlv3112764;
	Fri, 3 Jul 2026 10:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j4GAElMSdue5L6oaOy6YiiqdMP//d7RxDVHtwExZC1c=; b=
	qnd+pbf5FtKiOSYsQr60+gbGCCLLAGTsFWJ8lfvYhPV+hY+CKoKJuwGGRLzSFvmC
	4hHypArnBjXo+/WLB87hE3LZV35UMyasXzOIWFvdT95LNsH54S2lsj5zR9W2KBCx
	oCxYXSv7KidPq3SypgTRuLrugEikPRC8SvpKU+j9vo8eL3+bdqIjzpSbtP/jYyKQ
	i4PPEVpHTmCuDSyL2BKdL/iFCCHO1kb5dnUQ7hQRx1WywK4w46ytskZMVdyd9iwQ
	L43/htFwTN2RRaGa/v6jdfplQtcATMiG2EyCJTU4I8nPh20vjlPK+bn0QW4QIznM
	LR7T/nK9RomkeOyFsoCKLw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfjenx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ASXsm035316;
	Fri, 3 Jul 2026 10:33:05 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yugvs9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jesD44PfwFKWH3bkZHyYc0n/HSU6h58mRffymkoI7Y6jxeeZ2Y+/LYATdl3LPtErYaGYjPri3EgxX+KdJjD3SCfFRYnEbliFEjBxCvc/ULl8g30OHq4L+j+3VHWkCNXoylL9SwAvzW5+lXvDx8ACHZ9n4CdBMomyPzjxQfDoUlq8nZqyKGK4tQNhgOyG/EBYBacmrq7sMjKKImrsYY6D8b2dYQCAMS6hty/Zf1YChDAFlxgvZX5rMtQR86dfCIowdTjuHw/ahMXvL52LxPD+CZ4ogbFAD9+nKZh2YFLwe+ejvO6OSCKFF+Bao0HJPwM15hMKyknp4QToyVRBuFaEfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4GAElMSdue5L6oaOy6YiiqdMP//d7RxDVHtwExZC1c=;
 b=EdhtI/LDuHFHiMAIgLaDS8mf/A7hfoLQ/9pxGAyYc332+g192AYvgkdxD7umD6yV5yhvjrBq3t1h89Rk3FFB43MjyCJr0JSTcdiH2gkEOUxZCHns7IM1NpERYgf9ONnaeIOuubjdZxwXIgjaakRL7CQOVm3AiXmWMH+mDlTKRMAuix/BQo2/kMM9VTdKVK4dzb/ZcVd9WPG7ktfai0whzSCAisRUWbCmqYKs8XY8K/56BkD5sEKlkZ4BIUMR/K4R+Lyqd8/oAj0fUhgXI012cwsdsnXL0+Kn79uu8Whe5BkJU3sJ672+fmgWuTXZm0Q6d/BRhTkgC57agP/lSt2TkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4GAElMSdue5L6oaOy6YiiqdMP//d7RxDVHtwExZC1c=;
 b=D7hpPJoPoj1+/B0JgjSBeGXpExQwbAPI+kzC2i/s8UONuI0qrhIO7zjc/vP9nMZYq0rMxLCdB8f+4TDNDIDEPLENYFUIX4PSSX3URISfdta944japh2ws61zbfJX4xrxs82zrzpDARAOzLsqkE8Y9b6vsQV7fujmIGFatubSZsw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:28 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 09/10] nvme-multipath: add nvme_mpath_head_queue_if_no_path()
Date: Fri,  3 Jul 2026 10:32:03 +0000
Message-ID: <20260703103204.3724406-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25b::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: fa564527-1a06-41f8-dca4-08ded8ee60e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pKGraDklzKWLEThbFY6A6V/e2+MTTwMd7BRApDbw1QHcTixbfYwhcITiDFrs5m+x/uHlMBQGHFzovmf/pxPvZB4+l3N7NYR17ilaYrQpW3n8Kfw83P2BWRGMLbe9aUI51ZKvEocEOpJf9IyF+KRrflxf5NZhs+h5uiYMcBDzhuLgr27EaihSwqWC85e5RWvN0ciK39cQXHmiCMv5assRzU+WT+naGlRGbhynqIq7NypsnE1x3FoBevunsPck1apVDvLR5fRA4lQm+Tqxl2n7RM9nFm/NFZztINSnBV6sKmO28wPL6GGRGcYly/9++vbAcVW92dAZpVMoEK/zEYcEU/C/AzdVaWPiZ8D5y+e0+yjCyIdefzljTUYjJ1vfNg3fkKdWJKY5NAAak9LEVL3fanklHvTz8Hd5iAyeJi6M877aoAZLjFaSwi9XXDg+2TxdQCMYBw7amSnD1u0jWnMBw+b4wikJfGSYCrnr1R78apCTKHiO8qI5fn3IIUg31HvoeDtpYMPdILn6bJfMBpqvh4b0brTR6JhaY6TGAPiWOsGpXPvkfjvI7225/nUDNRR16e6FvZacKcuFjtFjAMpcrsAY0fL9fNh3WvnE3YjhngYgtIVKtSNg2R8YGGN0jMQKmmg3pLpMqFmDqij4uNSOUD8B8gP+24GARjsAl1ClFl0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oeMXKYJtX9WKUxFlmFYp/RSe5BKUBYfE0MYr1o6bcPRvMa7cvJEuM1Uo0X1P?=
 =?us-ascii?Q?+sGYWKeD5Uqj25fNqQTd+dneDTayJxini8ti3XuLPMbM4BA8WeC081qEttJs?=
 =?us-ascii?Q?fSqpJK6/eRccf7vP1NcfZ+wHvEhODG/l7mO5L1dyPh1qizkeNxI/Nmt4HCuM?=
 =?us-ascii?Q?GAIK2p5lT9cqpkOCTgvxdk+sc3vqamnfr2QmQ2Sm1KyVLGvIPKpFPw84q9U0?=
 =?us-ascii?Q?2q2SFHe8nvP7mnZKpQzct88vMO/Wkq+8CYUnAZZLgAZ91ZL2Gt9LnfkpZ4DD?=
 =?us-ascii?Q?TvWmCndfbMyiiU23XvakgoU9pbWowoR25dS4eg7JqYS9HIRMmYW1PvZYRBg/?=
 =?us-ascii?Q?CC2kmqE/V2mOttNjabZFGbZeJGkoat9MPdsgicq3Fgqsf/LDJ0ENiCQDCyBg?=
 =?us-ascii?Q?nykWOuHDAmt4bi0YcJJFcPz4Pdc3fnIpFRnohNylC880agZnMb5oPquJQpOn?=
 =?us-ascii?Q?NNtElI3aAz0deXRQNvmADe3R7zBps3ZztnVe2FJU4Z9RtwXk2R2zIfjmJuRy?=
 =?us-ascii?Q?sJiD/3gSSd9u1Lo72cpboJ7k07TvdDpl3hpxXX5edhN29v+oXOhpCeH/j8Gd?=
 =?us-ascii?Q?Zb7bqplYa1NYAvahcQW5WIxNigzmIjV0PkEZdvSYKpE1lI36P3ZD4Oh/lKby?=
 =?us-ascii?Q?wwW72JWnB9CImv7FE3EqoZcmFnzSxVdj6LDn+lBBFin3UqVIiit6kq5SZ2ns?=
 =?us-ascii?Q?/GBZOh+JDnq28NwyNdxzyAZeeFNVTTufdSZTICeqYLyMmFph4DX8DDnL1vET?=
 =?us-ascii?Q?O65mUAVqpb4Yty79VVWzJ9QEdTikMtIiZERZS/UQ1kvEeSWzKBSYH8SredPm?=
 =?us-ascii?Q?bZdcfm8c2Jm0EZHHlQW/bpi8SByjLLqb9NPUkNmW3cad6Zm3ZHbt3JcOhB6J?=
 =?us-ascii?Q?f1UiREegR8l1ZSpkuBhP2Q2YIIs/vFLrH/Gsjrygoe2/4mIKxCcbnwQFXhBs?=
 =?us-ascii?Q?I5QsAQNfb0nq7qR3Mr3nne65Z2lbRewPf7qy/sQk+BgiX598x/K7YtqBE1wj?=
 =?us-ascii?Q?eW2u2293lxufRrTL04TsOQILPEWhfma3S3WoCFk4tQwtiRq7+V+Z4ErPh/PE?=
 =?us-ascii?Q?V6qMuSQ9twfXNp1wlHTdKY16wZzOxPYZaPeI4JtZojt1nEWfCdQlGp3StVZb?=
 =?us-ascii?Q?r2EbhYUMIHAiTRhAXrFv5h/tFPt9XQmluaht+kSUy/jwMPd/6AXXemcCsHyN?=
 =?us-ascii?Q?+vKeMTBtnP4DQ83p24TEf+T698ecKDDC/r6PzfLEkLj6yFATinWEaHFObtee?=
 =?us-ascii?Q?hPaoeOFi2E/wSDZMAn80p4qfzAH/T/Y+MweVtonlMjphqdw5WeosodUVfJpe?=
 =?us-ascii?Q?ZP+C6pIV645E94a+C4Kj4chsZ0X5husJRizHvSJGlAXJuVvhPw6xZhAyohgS?=
 =?us-ascii?Q?xVvNIuWNnOUUmu6Ue/jMMSf26vTwxfMgTechI6EXYevHho69jhPzDkpU4vr3?=
 =?us-ascii?Q?DQm5IpC2uOkHqibfgXuSBQYPfaWdKIxE4n+0W0pi0DJ9S1Tnk52Kolup30UO?=
 =?us-ascii?Q?6IFHcIHpH9QKV2m2bnPH9Zx1I0nz03JDgVUhm9RqeExVLACYYvuFYcuEeGhL?=
 =?us-ascii?Q?P0I+PBGAM/F6mqhlGAJ6k7VlKQgGFSrS6HJIA597TSI1KgKqP/LWD+JVYawC?=
 =?us-ascii?Q?cgoRY6+JSCxgxoJw7zxeyGmz/qy5a3tBwflKfMOWYtCkpF7LOwCwit53CV14?=
 =?us-ascii?Q?PgNi/8lo3LhF5jo6TaWplBfLC5h9/xFlRXwb5CVL8zy47Uezp/yFihTUzO1e?=
 =?us-ascii?Q?u4oO7XJLmud1IXoOhetMSMoVYGAxOXs=3D?=
X-Exchange-RoutingPolicyChecked:
	aqtaENYWaAVJ7RuN7I7mJoGQWLj158+qEqQp3BWo+kp2nAq/u2FmbnRyVrkHteDfJY0VzJczo3dPZzIrvr4+sLK/FCFhEZECO3ti6kqoLC5nQgCxpcXdX4xPkPm7Vob9QiA9Lct+zhs0nIJKuKt4MOlvh8pJtxFyH0P7BGx5EDuWS9ZQ1cqzp63yt0YGAT0aNZBJIN/ahzQxDlqM+CWEL85D6BZbMKTje9ffLLrWVieMk1sco/QGfSv5hpZsGxQ6/5YRAhtg0Qk/QuwIMJOgsB6sSnIs0s71cpfCCvxxNsnk2hu+zC5X3RfpFmw542nZrpQpGYVtiCBmF/+zIyue3Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H934BuIgwItwANiGlxeJPgbg80waeRoMEmkBcd5mJrBEl7WI3jMI1blWsSQSF3Vj7gO4ZIwG5Jklni6eO7vm9B2r1NY2cWwprP0GylGiaGeBd3/okv7UDlsLI58wCbKfQkVD1xTmGQ6A+fDPp5Ewr/Derg+kQ54OC6n6QfG0hRJuDhks3wp/okRDScKPKe0zjvDWF8/sSjmkDm0verb+2gdQkZIZVVjhAq9Xbhv7Z8Ix74DXrwHX2dPNVxVqECw9A3xPjeuiNg9cIDwT7mbB2v1J7R0mhrd0u22t8ehH8Ov21aXHA6nZ/jVaBn6V4GeWgF3sZfQAwEHHHJFxbieYIISHloFlUUSAXiv2QjwEnuQxJldAwl15juzWovjy9Q9kk5nqauKO+NX3uEYy6ZIS1rraG9bGWhAa5prUaj8qBSBPQPWBV0KCkCAXCq87oXyCNEppZKGfWnO1PribBMpD6NLk/KJTH4sDtFLHLam5LK+eeC4OVPUTug+ax1sj1rxtz+j+Kw0sXygs7Fkm1kc6WMwNl0kUVw5QAcdMAjBVZleGQ/o5kXdjFDNMXu4R2dDbY2NW+opkJttCrHAEAoZ+fOfjO1RZD+DpoYZMRhb0Emw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa564527-1a06-41f8-dca4-08ded8ee60e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:27.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJuJeay1s2VXxccHf1QlZ/yQm1Nb4rN9q4ykSA0P7ZXEIMiEIgJrWe3u0weaNXkJ5UICku9wvqHuGZ7YFna+lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0Z2Yx/SZ0PXs
 R6IOPFwbtg462d8k/7VdR3jzYVIvw9O11+TMD9+L89i3ymxlv26NLUNWHPm+3eG1VV4zf0W32iX
 zqHvYiqESlw9263SEVgae/Oxj5m6/b1NA/WlvzCwGFXZNzyIqhOB
X-Proofpoint-ORIG-GUID: xHH9ORliR3DkGlUN5CCjFMd5Bp_DG_Ol
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX62ERlrmJzdos
 PnVh4esvYQv39dLgI/mdC9H/E94RuvQ7qI8iTZ07lOW2slbf2kCPuQeTzYgSFxzEWULa3aBvyYX
 Jyc26PUYTMVpejEJ8jne1fR1UyKMMQNJj9SGzE3C8stzO96OlL9RF2X144DuClPMHF6tED2tLkA
 CbdS0zwF3YRzf9vtoBZYg1POIOgkbJazCtbkcdfBcjjfNs9+7iIRI00/qLNcdehAl5MJiw84ojy
 UK8dnlftgax7q43l913PG7bcF+Geah1h4bj7NYCEaC20ec0XH9DWNWk9FV0xDVqTIhQ+ybvJvls
 7hRiW+nFXGvOQK0JyniPuQOyVngbK29aw/W+55n+B5PM8qSBVXRRxM82wyAbAEvRB1M23L8ISxg
 FM3aPRbMLaEU1vzAavByfDBeOYFqI5cGFRFr3zJtGg+kU6cbzmZx2NRY1pKazIH7nZQQNikh1g+
 z+5BeT2iXt3ACY7Zn7h9w2xtMn19dT4O9u254ylE=
X-Proofpoint-GUID: xHH9ORliR3DkGlUN5CCjFMd5Bp_DG_Ol
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a478fe2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=Aed8ZSgTGLsvUS2N6I8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723

Add a wrapper to call into mpath_head_queue_if_no_path().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/nvme.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9fd958a426f1f..354f77dea4870 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1095,6 +1095,11 @@ static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
 	mpath_synchronize(&head->mpath_head);
 }
 
+static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
+{
+	return mpath_head_queue_if_no_path(&head->mpath_head);
+}
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -1218,6 +1223,10 @@ static inline bool nvme_mpath_queue_if_no_path(struct nvme_ns_head *head)
 {
 	return false;
 }
+static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head *head)
+{
+	return false;
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_ns_get_unique_id(struct nvme_ns *ns, u8 id[16],
-- 
2.43.7

