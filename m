Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BAB47D93E;
	Tue,  1 Sep 2026 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259605; cv=fail; b=DrMDkxuT3PJtFstzC2OMerENYN1jeWZSuO++dyjV42LguCPQhf+raYWtLhAllleC09S58cJ9cqga4awpDDaghZ399wF5j/p1NPgDnZKfdxrtE3n6SbIBRPXkdGmESVkkaoggk+s3YVvWNF9FWHFazlt2bAc5hJajn3TPwiAzS8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259605; c=relaxed/simple;
	bh=zLtfhO6Xv7wCPv5w1bY4bMrAQbh6OD7k06BJwZhkfpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rh9t9ECmgW9kReH+/mfEyTx559zrrxoXZ+0VQ95syAGQOUbLl+KAQURAM5YzMwsCEq+RJnKsVSppOTDsmD6vbX1Ko0Zi1JHxBsr75DufqBuhHKGLHwdp5goErmuqVDdf0ys38h7zZaC0Br0qNcbH9zWFSBGOKm+/W4CLvuDprnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DAo2twGy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uddN760V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DAo2twGy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uddN760V"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6811rrEr3316819;
	Tue, 1 Sep 2026 10:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J9o4ieBmGZL18Q+OWSm9FZGpiZapsYeD98jP3kX3/i4=; b=
	DAo2twGyT0VJ3vNcsW/y9ldQzzei694ts0wHutfxBTkSin36ZwAFdDgVWxAKe5K7
	0SBIST6VvnjDHUN/g8fKaXqOxL9FbeiY/FRVI414VS9dzeqtGHzlkCgwuoWOSf2H
	4moWg3N4cVX9iGDYJQbC0vEyE7OePvHHLodArD1KGYA0d5OhkpkFlPRE22SXxh3c
	tnaopz9LQM5R5sP9sNm1yDTqa3X2MuBJcuXwHyP25dUc93CQptoFgtwlAmYpbXyg
	gkOnqBq6ZWZN9O2YXx6FoonibkR2zRLqQEzVikbNJVu/gEGbGZmiE7TtlXUichxN
	9ibCzsj3/lbH45Oq67HaUw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbaveg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjMx5037329;
	Tue, 1 Sep 2026 10:45:42 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve3463-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcNGvtorZKskQKMuShFwtDSkwff1aTCIICQLuSTzbxS5kEUvqej5QKEp1dQ3mFVlOJOwAr6JQagBR5PqI16osm4GNZ0a5v4+Pjrn30ytXT2dWRvAUJVD4BUP2Gq/sp1pts0VMC6Xm2sn0gCQizi+fPyvvpUvvbv36EVgrrFTV2qC62SKDPsyIFtsIToKIqKKDMQ5KOGBXtN5m35jTjxL824VAeFhnmG573S1mukw2F9cCfhx4nRu9PNawntgEfKl+fwYo/OPW2+GGTSemUlZ+rwnAaO6/xb8+/lrqKJcV/RVsasOvyXsGg3q7edqCrh48u5oWwruhNo4BIDuZOjgjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9o4ieBmGZL18Q+OWSm9FZGpiZapsYeD98jP3kX3/i4=;
 b=k2qWHfUF8tTxQVZuKQ9Wp0cTGj+l8isHCmrvGZDKGto5BehuDrssoCMHGmE2mCWCvMa3KVp01AY186xbT5QcC5iPE6ANJuOKQxEPDSMBaHyz4UBx7S5FV+glP8wKzM3YOieA4pcIUD2aBOTODT/dZ9CUeXx0cTXbMlwGPHwAfsXe1Yj7UscbwyutFjkt7LpqKveTAmFXijts3+JkANM4MChR8UAeRlo8pc42Y1BsVlu25z/+C2/Gstmn9KnNCLo1Y50RyUa0l+AdRSBY8PGZQlRIfa5VuzsCybAwFnst0q7PMpdfY/2aV5lJ4MhheX8leY5su7Uq5e2MvJdRAGkY7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9o4ieBmGZL18Q+OWSm9FZGpiZapsYeD98jP3kX3/i4=;
 b=uddN760VJQCijbnGu7LUJ0xGX3GKBmSQogVXAJ39QOXfCFhKTODFlQl+6xePA/H6CZDiQYaPf5b8WVss4FJCcRZ6pr8GdwLfVgUomyZdaZoidg1dLOzOwQsHB24oOtanbwI90U47JsIQ3EKCjhxuW1+Nw1MGvh+KIbCZe+MI+SE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:40 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v7 01/27] libmultipath: Add initial framework
Date: Tue,  1 Sep 2026 10:45:00 +0000
Message-ID: <20260901104526.3850621-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1e7::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: d777b54d-4788-4ed1-ab32-08df08162a25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|5023799004|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	JpClAxGSb4lndJV1M0NmU9dANOZzcTx7MMkaIj4gBk9MDxxipagwVEUtY8GxTk+d3R4xrFvEPiRKHznwt5rpGc06m7uWwSwcaOEs2qKLhY3oVp7JReyhgoSXaqZRk4pZLPTFJEG8JYqMpSUpJ9QrX6+BO22k6CGehzZUorn9n/Bo0qG8g9NVSRSEiw5MrTuStwe781n2H0E2VoR23lHWNnK6s7TJclwb+bANPwg+m5aKgo51jBqst2nGkedSrc7pm3X+pRfkQQ5xhyqa/npVtcO53uKvn07+NnlNOspg589b2j079RXFqLNFRfGnN3cP/odolEYZ9Haxp6PCaD1ik6YsPEXK6QIN+kfHSy7WF15s69anYEprgRlNau3Mxpg7Ven686nkjLP2wmrAPmETnKh7w+tv1iwUIMK7pxnqCGeU9ApUBFLD7mvB7dDmY8ZG3+e8Pon3MHBXAtJF9TU9dHAYqtx1jeGrqj1SNHDng51QnDc7r2L0CCaO3370UNxn/D0b9fscx9UM66Tu9dWTEbVTUxwGLUYZsPRTD7lt26QT+RikVgOBa3aEuZNUSKzDxu7UEs7qXzRUTyNpgoBdmRXvSgkdoPbV+wQZF3q3CMG8uNIfiDCY/LUsorw2/iXkWpYKFPbmkCV6wfFOnJn9Pkh8sJHu2ZH1N8l08Ezp9jI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(5023799004)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zafI1dWB+Z/nAKF4N0TUNyzWm3fxOZBm9ea6PCUg+Q8fAvNTHDWrSl/1OVYR?=
 =?us-ascii?Q?8EjUHCR0O8b0COhSp6DQcVo5+9XLSxAAcLeIMvjT/a52mZype9F8bTTTeLe3?=
 =?us-ascii?Q?ejA4l8AOQNlQzzD4NC5xxMziqZkyKAbE37TkAU1tEvdWkQUHgnhZ6Mh3H8u6?=
 =?us-ascii?Q?mO/SnDu/7STatj+o9bhzq7Y6cw8wQ3V/JC08h2knZlogB2yI1eQSIdADCbXb?=
 =?us-ascii?Q?f2oiElss0lyNtam+nfTFH63Th+HMDD00nKGZ1BnrZsUksr9ewdnID47GB7VA?=
 =?us-ascii?Q?Kt1NTZM6c3MQnL/mcpzEiJ6RzRH4c/9Db56DE18gt8xTTxVwz0NWGtsfTjD3?=
 =?us-ascii?Q?OrpO7/v3MGStaSx138shjsJ4kZa6w287uvwW5EaV1X8bukYtTYvqf5VU8wpT?=
 =?us-ascii?Q?68V1VqHK/CeyBt+X0xrHf5GJBdEdawN99E7+eFIjSDNSgwqeHFQCkYGMlCp8?=
 =?us-ascii?Q?hHdwa+mTLtkialF11QoqT/9tMFiTicnL9e8hUR7BG6qfHUZNzivQjYLF/OyZ?=
 =?us-ascii?Q?MGs9igSNVN/MMM/PgkObT9DbDs1OOXMp1TdL8BWMCWNpeSeh8ZsM8Ntqtm4C?=
 =?us-ascii?Q?fRWgG/xiOUFoNfjyfyYd/FofSSmiQ7VJrOSftONfdHb+T8XWTNYuiWNtRlZ5?=
 =?us-ascii?Q?CyR49s7O+TEmog+uQB41NIucQIrLALJSfK0bH1G+V7A3tykdVXN337Hz5Pox?=
 =?us-ascii?Q?L/C7DwRFnakE2WpWbpv7jepO6BWEzAiztOyCwrr2tt+N1R37BzRvgc7QGO85?=
 =?us-ascii?Q?a6Rbr3JCTkIRXOJlfZIRY76uJzkvZGJah9ONKoJTahAPVl73DYhEvW5/OwCo?=
 =?us-ascii?Q?BKU7ClulwztL9vCsv35CRZ8zCLn0VRFS0WwXFuneUOU7nqOoiHPrNGmuq9us?=
 =?us-ascii?Q?Ybnt87LCr75rM9Ibq9svZq90bV2PefPLv1GVwR4Dal/g63HYiLmWInM+TrWr?=
 =?us-ascii?Q?/plNDTPoPghGaB0eIO4Xajurt9f5mBodk2RQQHOTpe28MmVqriwkaspji4k1?=
 =?us-ascii?Q?AeEfugDtH/eLTawPr6DBaS5VJU84hSNj+WvplZZcLbunjzcQOIRuQvnk4sSA?=
 =?us-ascii?Q?a6DvLdEpH0jiNTasaJhNgRjracE8HMB5J16uoAyjj50MlwL8qYeRZmqdRJjP?=
 =?us-ascii?Q?38BrnuSRqxYw24AznzfovvSSOlbc2hXxMcGNbhi5XIBx6n4o76EyulHUTN68?=
 =?us-ascii?Q?J7XNhyu0uI5+4BpKnQOs64XHtjt3+dOIOdIOgcA2IWMEvepVicU/p1cx/Fc1?=
 =?us-ascii?Q?P+wxcw6yyRGl0j8UMd269Zz9kOkUDlHv8FTif444V8lDWtD+asQ294DBnUJN?=
 =?us-ascii?Q?8BkDdDId8rQRUIz63S2x+SqepwyF+rjOf454v4+pK5s207CYoyMLZz0XIcB2?=
 =?us-ascii?Q?EIbmVOX6dlsF7+veRhh3xt14KdLf0P+qx+G+slsWGcUnsonNJgcR2xkFAdSU?=
 =?us-ascii?Q?eTIBTQOTGrxk0184fIhf3hj6YWGKOPt9FGbTFYZ5WcCj8q16Ce+gs5i5vCbz?=
 =?us-ascii?Q?rIig5uuv9F5oB/YCmVEldPaVdKkWoINnbreGYYgmCApxlaiZoFxwZWkD7OSN?=
 =?us-ascii?Q?q4VhUk7KDoYHYAxENAyFzzyU6kBSzVDoJGYDw/CVMNlwqDkA3/Ic3rX1MKIw?=
 =?us-ascii?Q?Ir4EgTp3O9Qh1dxKZbf+BsJjtpEo+fFjXYhSCKCVwDREUlqpgJLhnkVF2tmb?=
 =?us-ascii?Q?M6HNofldHZ/B54F/cxsx06Z1yd7TgwSfkuxVO7LQQNhkWHRzLpYmIBQjeDJA?=
 =?us-ascii?Q?ftKRUYGP7X/3c0QxWu5rX9ZqLyGCakM=3D?=
X-Exchange-RoutingPolicyChecked:
	vvO+RtCGQWO7ZED3mM9pBKEvfrMLK068FHzBP64h+oxn6Ta43LtrEdk7d9AS0fCjCb9W7Jk4NBgMSkMEneR0SuncufRPpebybaSoqrmMWTD0kbe3TfsuTdpFdk4/Ybkx5QE/Oi+aYfqciiSmBW43m1+Ya0lBulw0PyxKIrFWj+feNPI00LIBxjr5fd/wfV2kgOEjX+KQYNoc7csAhNlwC/pre+aCTuCazsnIBkiTcthRkHQShWHZCe96Y53tIsDyZGSU90meBQe3KyX9Wiqp8XQDodK10HErtkQ+X9DCte5luKD0SAnrwI3kvCexGwioS88ujRN4a/TZwcxjTe78Ow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YDWkGWqKFbHC59DWWTjIGDT7Y0jHQyEOj3d0Gt6oFvoq+i70xWvl2o/zcXEiGEstjbhZvgBWI8y8oqMytOcBlL4eYddB3PJQFkoSuHkzZReBcBIGICJZWlpi1jFr5Gmq3Y+3FN83AL9Xp2fT0lI9qSkAl8WLB4anX0gPdvAMp76sdUGm49VmO9RjdlhG2Pt4d1OfLcT+RhQLiCXoVP+EjiYhYTsxd1SzFGk7dDgA+CyX4rggoJNFB0rPr87Xd5GlWyLkzk9xRKDw2xKjBrgDnkCJdqRLvT/BNio/t2vFUGFE1J8s+b/jsSIC2vGo+7FLJY0MSg5XVaefadEY2UFj9VYt77SVq3nJhbI2DjUmfr4K24HvSlHn6r31Fx1l3LRJv3Y05Sf4jaCW9E4nbXfKeDw0Z7HeXHgkLt2ldnJLxo0slpZ7PJLjdblGlT16JBk1gT0TmlZxgahKmZAL01nYK9qJIWmBdvkw2XwgQ9MHefNm24i2MraphBzCn3ZTF7YkC17BSeW94A2hcQ1BPgiao5+VedlfK2ZnIOFoWFeLJm3siWFnnpNa/5j0DTRjgUPeV1LaFZaiqlQcrCwzgcmxtHzGH7kjXHraDZkD9/d2F/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d777b54d-4788-4ed1-ab32-08df08162a25
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:40.0752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hs6JlAbdNc9zWlOWsD0dn8usSkLIdd0nx12H/JrRZBdA+4hp+07XtSOAhUumpgnrf/HJWtbOFC5F/ORWxSRvAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6Zf3jt1HpRCo
 mjeYxn3c1mH1MHAu3EymIHtQXNlW2kA2e12rBsUg1ufya8qI3TDPEmwg4b7nTvtQ3mw0EJyO5oS
 Rtd4rPMDjwaiyJtMhZyOmpNaAzAl5iI9/+ckiuS2HlKpOTMfPX9o
X-Proofpoint-ORIG-GUID: vyzcNErQDkIyqicrZ8c_4JDy_DyYb9in
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6s2qpWkA/Mkv
 jLudpBEjjzdVxu5FKFlFvWtgt+XCXsVS7biDGMWcqOd9tm6ZnbEpOXfje7TjsmoBfcgnk4dMngX
 NGnAGXBUHTV4BuME+lPjIPVzY1nhzjsP9VHJSC3Evt0e3ricJv3HIUG244gGkiwdxs37yFQBBZR
 pjyDff89yKFTghFZRoMNuETTwqS9Rj7m4YStmFZghIZLegBPdCaTPQjc5IMmdMD+RFOF82Iv8A+
 5It8oVArKEitUt7W3sjZ7bGmxQCQCbUwDmpmAgpkoTKEUYTdBYMOYQNVy7UK5+NmawTuw+pn+TS
 C24Q2nm7KmnVTVQZrwR0KFdQ/AE2MtCsi4eoz4CnieHQg+toVvKYjpg2XDEo+UHfvbLCoom6Pn/
 jEg/F5z+EtHZEjHKqafUAtsdoyL/p+lmOWAVLfRQD1oKI8ZIjvFHUrPMzovip67WYq9Ik6wt3ZO
 sJf1bQp81XEKIHi86jA==
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a96acd7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=IMLwmY2krkRuQTCR-eYA:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: vyzcNErQDkIyqicrZ8c_4JDy_DyYb9in

From: John Garry <john.garry@linux.dev>

Add initial framework for libmultipath. libmultipath is a library for
multipath-capable block drivers, such as NVMe. The main function is to
support path management, path selection, and failover handling.

Basic support to add and remove the head structure - mpath_head - is
included.

This main purpose of this structure is to manage available paths and path
selection. It is quite similar to the multipath functionality in
nvme_ns_head. It also manages the multipath gendisk.

Each path is represented by the mpath_device structure. It should hold a
pointer to the per-path gendisk and also a list element for all siblings
of paths. For NVMe, there would be a mpath_device per nvme_ns.

All the libmultipath code is more or less taken from
drivers/nvme/host/multipath.c, which was originally authored by Christoph
Hellwig <hch@lst.de>.

Signed-off-by: John Garry <john.garry@linux.dev>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 include/linux/multipath.h | 28 ++++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 67 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
new file mode 100644
index 0000000000000..407d985cd31f5
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#ifndef _LIBMULTIPATH_H
+#define _LIBMULTIPATH_H
+
+#include <linux/blkdev.h>
+#include <linux/srcu.h>
+
+struct mpath_device {
+	struct list_head	siblings;
+	struct gendisk		*disk;
+};
+
+struct mpath_head {
+	struct srcu_struct	srcu;
+	struct list_head	dev_list;	/* list of all mpath_devs */
+	struct mutex		lock;
+
+	refcount_t		refcount;
+
+	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
+};
+
+int mpath_get_head(struct mpath_head *mpath_head);
+void mpath_put_head(struct mpath_head *mpath_head);
+int mpath_head_init(struct mpath_head *mpath_head);
+void mpath_head_uninit(struct mpath_head *mpath_head);
+
+#endif // _LIBMULTIPATH_H
diff --git a/lib/Kconfig b/lib/Kconfig
index 4e6b34c3346d5..8e0c3717e8e9a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -630,3 +630,9 @@ config UNION_FIND
 
 config MIN_HEAP
 	bool
+
+config LIBMULTIPATH
+	bool "MULTIPATH BLOCK DRIVER LIBRARY"
+	depends on BLOCK
+	help
+	  If you say yes here then you get a multipath lib for block drivers
diff --git a/lib/Makefile b/lib/Makefile
index dfab958327c5c..7041d278f2d1c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -350,3 +350,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
diff --git a/lib/multipath.c b/lib/multipath.c
new file mode 100644
index 0000000000000..f7b26c66eac7c
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ * Copyright (c) 2026 Oracle and/or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+#include <linux/wait_bit.h>
+
+static struct workqueue_struct *mpath_wq;
+
+int mpath_get_head(struct mpath_head *mpath_head)
+{
+	if (!refcount_inc_not_zero(&mpath_head->refcount))
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_get_head);
+
+void mpath_put_head(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (refcount_dec_and_test(&mpath_head->refcount))
+		wake_up_var(refcount);
+}
+EXPORT_SYMBOL_GPL(mpath_put_head);
+
+void mpath_head_uninit(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (!refcount_dec_and_test(refcount))
+		wait_var_event(refcount, !refcount_read(refcount));
+	cleanup_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_uninit);
+
+int mpath_head_init(struct mpath_head *mpath_head)
+{
+	memset(mpath_head, 0, sizeof(*mpath_head));
+	INIT_LIST_HEAD(&mpath_head->dev_list);
+	mutex_init(&mpath_head->lock);
+	refcount_set(&mpath_head->refcount, 1);
+
+	return init_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_init);
+
+static int __init mpath_init(void)
+{
+	mpath_wq = alloc_workqueue("mpath-wq",
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!mpath_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit mpath_exit(void)
+{
+	destroy_workqueue(mpath_wq);
+}
+
+module_init(mpath_init);
+module_exit(mpath_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("libmultipath");
-- 
2.43.7

