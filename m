Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B52479883;
	Mon,  7 Sep 2026 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778315; cv=fail; b=GuIb9BiOPGUoG1iNpboLmn/XpCuveAtGPkJculeIADuby0GnOP7dolIzTE2+ky+DZS4pOtwDgu/mH9IHYtmHRzF37Jauss0wAfCmMUS96O1LpTnz9wp0oxLWwi/dckjIN5II4DzhWJst9H58b35H64P5rI6CznOy+4RC5XA1NLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778315; c=relaxed/simple;
	bh=/a2yLf4VBqousiE8vOzP0ziG1hShZTCR3ae3nt0Yc3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mSlCkhnhN07rc7/mwjfegQFRNhk6jDV23tDqj1WU40kWxJW8utL1yIjDp5ZLL4AfgGNk2+3yA+7kyUc0XRP5v4IP6m9l7ezK5jQcO5o5wR+XgbuF6QFm3LG82KaQCOBmoIdCtVoJ702UyfTOW6iyU9KnIWTstrGsdX603H25HJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PHppOQPH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EdJnm+SV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PHppOQPH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EdJnm+SV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870ocJs289152;
	Mon, 7 Sep 2026 10:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aHmVfLBj465DRwXL3wgNa/r4s+3paS/tfbwtuKSqN70=; b=
	PHppOQPHSNxMIEh2fI6hVtpOr4h3iQPpD+rGAgh8lQuYlRV/P63V8MWUkTvg5x9M
	LklUj7AwtxQ3XwhLWsdJRhYW79+f8msAr8dC8/t6amveRbflSO9LIMuHRkTV+T0Q
	6MXNoYWqaD5suRmANtI4wj+90qB1y/wEQueH4+LOgP0l9D3K4qnT2y+e8aFEeWb4
	hD/oeOS9lXgjuqgKY1Q9wfbNXL5NpYu46r1dc/WIiRiyqeuSxTZJ2AnvXWavwoTO
	Gw5TUCf1vR0LsvvLXA8CbqhtqAysXA+8qLWgWqIaILw81JAfvCv96xSHvahE0Osj
	Fjn1cwO70Eh2FFi3SKyXTQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbhuht0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfL019106;
	Mon, 7 Sep 2026 10:51:21 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJd3pg06yflSL64+5IV5CvoLC7esBnMp67cw+jJJ7ETjHYggeW7CGOF2JFsKBGTPjLLgfsWYmff/vQr33CysiZ91f7JsC7tuRwGH3w7z/AW7dcOb0kPlugH8q4H6f34k2ND4ilnYCJNgJUr4M2yua923JgVNOTd4BZntSA815Id1uPouHYEuiiFsul2Vsi9O11hzGwy04jE/FhIFTYr8NWfNtUub0tYyaE6MP+EECDXGlU1vqqZoqId0bM+LhJ4OQEhj8oKFhgHF1IYrOJ5t1Q1zBDfWRyXrHhf7LFbKWHIczHkKMuhGzjPPPJnEHznY44IxKB++uUu9EcFQkugU5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHmVfLBj465DRwXL3wgNa/r4s+3paS/tfbwtuKSqN70=;
 b=AdpmkFL63S1FFJzSKU3FSLJzS3off6x1Rbo0G8mXQaiS7Qx9O1zYnsAcG2Fww9BcUxvpP1WeNafZcAjZ6JXF1X+wGQo2y2h2Bqc9nGXORatGXEsSutZIARPPUgTuvV9KviOTZ12V2zECssXOE7QN2TYjCGed5+bxw6DmomybZGbSgmZGE7m92r8i7SEFjUN2OBUTGaK2AV3rwIpLVvZgUpVQa1w4BYI6pa768YhVE8eOG288CxWH06oPz2/lKq112/cUmUwkx/J2CMtBBndJWUskS/6Yq6ZVTtHGvoec4ZqVUwZmmXcfMmZ1fbyA3k/2l2oee3swGKIm4wv1VG+0Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHmVfLBj465DRwXL3wgNa/r4s+3paS/tfbwtuKSqN70=;
 b=EdJnm+SV7yqBVmFUI8HenLL+W6kvvi5WMTNGdKNudXh5Vw6Xcw2nah5XCSpeiqg7SAOgUQ6mXb73zXGzPEIkQWcyhdkUQGmQwLis+ApX2plNwNQoD6WQfGKwtPfeW3oOq4t3PiZWgJDxTipjJt8YG4VvaiN7j0gLq+RxYEO6J0E=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:14 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 19/27] scsi-multipath: provide callbacks for path state
Date: Mon,  7 Sep 2026 10:50:13 +0000
Message-ID: <20260907105021.1763236-20-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF000040A4.namprd05.prod.outlook.com
 (2603:10b6:518:1::53) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: acfe45bb-34c8-418e-996c-08df0ccdef49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x6fTBY2+yH3OyAu2MsLHuUWC+7lgLVcc7apiiBPit1SkjT/1RdpWZ/1hlqcyLSdsTFpKghS2ltx9sS/QTMLpwm5TaX9j6gxAkucjNLK9aKTV0+mV0ocXmWdrGoDrML1RAl3qW26cyiq91cglQkm5EeEjwQtrWG/dMG4DMrcCL8QEz3CIX9wHK9NKcWoC1M9yI2+OsMJtCvcFNJTDcLqYg24vHigal/al9+rjHsDg1eKd1PxO86BHS+5EEmpLWKhOXs9Yo5cx/YAaNT5ig4+24YzLjM7F99Skz6BehJbK9p9+pwIR99cWuk63iYOQMKcp60l8ZZUy0MZaltz2Zi4P4twHDaLpo7M0hcRJlXKZRyp63OxWvIMjPCIy8V1fTyX/i1Bo0pxstkHX8Zihuolh6/x1fnJWnu56CFs5GKI+I3v+xs1YVotXLfxNzPo86pCsf5iGzmFKO0w6yg5JYaFr0J5Ky4BLAwB/bWke48exwVFev9TdFoNh2DVun92eGXI42Nbm9b6oTkS286rNRuCAHA6ThVJiv3GOnxPEY1464XwannU4DW35VMe2yEeGZcJz+IMb4qkiGtSTKSxjwAN/xl7xnLJtUIP3yZmOBzifGcbNm+v7DBwytNqkjfJb81QJ6FescENMuCGOaDqKUhCNSrPYdMlJKloMxYSOU6U9BLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6QnDiCEmQ4h1ntK0bqaF+2OUaYebYRCDllzDO/+GSYWSfqtz5vEi+Caa9lhp?=
 =?us-ascii?Q?bBVfdnkvLqWHx08AM/2UnU7Ta8E1Yp6hIFrlKKi78xsNnonNxFMS5zznI5ZV?=
 =?us-ascii?Q?PX6swPjIw+jPaJTVpBKIu+x4NkOFpXRjkCebccHZ+aWoSLjdF++VP2vBtBWo?=
 =?us-ascii?Q?auTb/h4qpjYcpld3PvLL0/VyWDJwzh25CTgcM8Sgzhy291nzIRpKN027XyRs?=
 =?us-ascii?Q?uMOmpVuEvKGFQ0tt+rDk77TZU4887nNoYHtoQziFn/q5txwXXwuDb6i2tONR?=
 =?us-ascii?Q?BvvvaEsCpXd5xwIqJ0uAYS2aFlHmxv7AULWpF5ZSwsui4kNLUlToS8SLK09z?=
 =?us-ascii?Q?ljQGe6Y+JwZIc7pLyOYF6mhowLFllw3N0M2NOz6Cvyz+hgnGgYJVY2sRtdFv?=
 =?us-ascii?Q?4foOemi12/3YRwJPg6//jAf9JzeA7d8jqz8CJ4mtW1rox5n0rDJ2ClsJZbLt?=
 =?us-ascii?Q?inx9AVEXh4snW+VlvAOzG+6Ttzh1NDGD+P+iBMPufxac9/yozaG2hFxQ9AMi?=
 =?us-ascii?Q?X3eR2naiCYtwG9pnBblqUd5Nd2ULXr0KVPA8g7MUVgq8/uDpxza6pz1CJ+a2?=
 =?us-ascii?Q?GZ7oAGM3bIWxT/1tsZIu1YMFn1yMqnOs2aGo9NbngaUISH+LeOoreDQjt6FR?=
 =?us-ascii?Q?jh3RWzy7n7Gm3c75fJoZ4RqzwZawLUxIzpCP8w+hf6ODikH4u1+EA16OmnQL?=
 =?us-ascii?Q?9/zQkb6Or1feUSLFB8hall/53XMTRMTyOKJwJany88+w3cH1LKKVgY4nHRdN?=
 =?us-ascii?Q?jMOAgN9MGJlC4UJvMwaBSaapx8pWdPEaa/CNjgWRrUi+QStjYJsD0siOJq+a?=
 =?us-ascii?Q?XnWq07mvkQeVIJC6VUHxBOAtEkZbA2ntJUuE2HrkWn8wWUHTL0eWYFdZ05e5?=
 =?us-ascii?Q?8i2Xn4WCBpYdRAno07FtSwTLhYY/ehajtOlLhHAGMmhfFTgI0YukmWwozW3m?=
 =?us-ascii?Q?m0PBRhZp4HngRP5KbiJbcydpiU8UoDxyylIKNISgZHt+tDdniXvuzSGaSxV9?=
 =?us-ascii?Q?M5l2YPgcEJmaGe4WFW+Zjm8vmn62zlrP6JNez/r69cR1s5lxO6OH336FFoQL?=
 =?us-ascii?Q?I9v7idUufhz03feFYq7Wzp92Q6xrZKPfgcZAga5iUcg5q6w0L4lIZcppWVVi?=
 =?us-ascii?Q?cYZ9eo/wAeYBRQ6FtG+zxO26gP/Q5NCBIpfX8r41VfKnCnkjoKvy1tV0JGQL?=
 =?us-ascii?Q?saI8V/UCvlqqld8BKN7njoVs1AQls7ywTLWSaEREuIsr+D8S9CmJGrAhqVe8?=
 =?us-ascii?Q?Gx9ajKkSwco+y3mYa3zWBYa8JC2eEAOE+eR3aTmTLhdIu4qerOHIb8ZmQxJI?=
 =?us-ascii?Q?bYR69d0deVhdqQk1B6RU4uAWaTtmcxFkghEziHhROi+lrPe+OCO9tOdgg29S?=
 =?us-ascii?Q?fAas+B7/58Izv7lVpKd469ScXr08Fg9y8KetO4UUxu9Qz0066PEOQ+ejyGf6?=
 =?us-ascii?Q?UOVanMgL72tbckC05oGs7hmUOFzzS6WHsQZG4nJmbdOWT+YAE0cZ40B8zaoX?=
 =?us-ascii?Q?DTTfIEUtjTP/I+YKpkyt7zVgmhJ1JmM0Qw6f5EIWlW1G4Y3gQPh5wsgo6W58?=
 =?us-ascii?Q?ejEzGSMPto7veGOIQt7fNml7HNFaJZFHzQE547YVzKZ9X7IuBqcGfvAGpTUi?=
 =?us-ascii?Q?Xio5VVwLi1VVzuiPa20YlEtG+xke6AJYALBJyf7/D+6MMjUC9lQHdGsfVM6F?=
 =?us-ascii?Q?jkBgcdDP/4pQ3uBEL7pldj62KuX8fbzXQvaJCutTnb6tBXJKNDc1dCPdNXI7?=
 =?us-ascii?Q?v0zRB5kkwQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	MBm/BoO5XyGbeddFsEm19m/54RTFyRqLs3QprRHHWwTQT9MyQJVqgf6v+6r6p3n1hfoPSi1W60Uw2rq7manzr1lv0r/j3foNDV6l3hNkECENUfxFByHEh39QLDZkAysYQy4MjSKyH60tBKO6E/DYLWstjHvUg29YhYJ57TutQREjKw5WkyGuLqnw1rJpgXkMb5sWFDh6PzErWY/HRNuGTBqm6pvKnfr9XXKZQJxe12ABVGNwrhqEdbkBvlDt3/MoXqiKW/mn42ois5obPJ6JaGimmLNCmefDgyGvhf4u6m/espe5or79cItfLmSaW0vRscG63GoHqjjaOWpAnoTjPw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ndI/kI2MB/HfHRvayCs17e+nBhJEC5uOR26swJIHneOv3ucd2ZwsXonIQFzP0bGtsrjx08XWTcoKJX9wDpq4sQPW1H4qRKNEk6YzdW1klZj7ezs8FB9c+FCrI9+7pL9/Gi3wRGu73OEK5hlrCUMqcjZndtBZPs9joV+BUGS2VZ1SWpNtbh86lk3wsOQ73t4cU3Zjn9yHfTHjTPN4wz+OIdfhwIEGlk6fhovQpZgQHsFWp08W5sf/awYqlM3Ux3JN2kQMS+AfGMXhvjXa8SjxMkPIa4IqmVtqsC3qB6Q6F3+Nva/UP7BgdIb/fq8fVDHYUDoKWeXksiBiL8CG5uKR3Ku6UPvIls4DmWcKiUYkYKzVJGH+IYYccdGEHbTKINWJD62t0PQKRFldI9pJZ9tlF/5gvCa68KTjMJB2UaV9544h/+haEx3BDl48sZmMHUGhKp4eRn194D5B7VJV82BwFq5nYJriXZUINk365FZNBmoxu2/741vpDUT0qRRpLJUO80XpPHg13vNv9sd9AssIdW8UvgtQ9n9MeMrxDGuDAjgDuiZLzVHZfPWl4QlfDUvbNGDCGkuWWUVuV/VH9Ml5VVS4klw1dm/jr9zdr2QHaxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acfe45bb-34c8-418e-996c-08df0ccdef49
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:13.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yvq5ra92D6f3JWrJoixJWhYRU/I1XEJbga4eHkrGx/a2HIpUQvL1SiW9WQgR+x8d0+y/tBoHlBG3i2qs319/ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: L45k0U5TobFcfBf97aV4tuHE9QtYKskh
X-Proofpoint-ORIG-GUID: L45k0U5TobFcfBf97aV4tuHE9QtYKskh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX+iG0NECKPw3R
 w3Nl8u9bazXh7VANv99jTR4fLZqHsfhf1Gr0jaC1DjW6AmwjyTaOnb6uEzOwV+kyRvPHEGsGlbA
 Sw+hqw/a1RyI2Sm5vAA49KyTb5QOho73AtKEpRC/Cbdz1Z4WoLKz1nKgiGzxuuiHe1AdCiePw9p
 v9ZlE0ixa0ummR+G5M9TTd7iXXC3HVwMZSfsY9V5jKI2D5NAeKvDLMfGrTph8MpoGlYP87FEb9U
 7CaCh7oN1vnnSnvtymN2880sMxzpF2wwtsnWPWqzaUjvTGxDkgev0/SVjznVp2gjM0WwL0IJE7G
 aZvH1cli2QjFmmMwX8a8ZTAB94iWvOVdjWBFcEDBhAhK35PrEsckaO70TuKeeWbTfbl2sv4l+Zs
 CphlOwifMdgVbeZFd8tynCqfAgGrmmBTk2DuRX5klsaou6VNAlcHECp1jktgvyKA1vJyS7pBCOT
 5bMn6IbiNCC4KQhDrhQ==
X-Authority-Analysis: v=2.4 cv=S4HpBosP c=1 sm=1 tr=0 ts=6a9e972a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=DHJJM_rHgSnfI6yttmIA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX0rkr+oc20nMl
 WafM2AXnFXbOGPpEP/YX18RtUKAkyTDNItNVz3D4ba9t2FunKOZTN/iDMfCgIOHgp41rA6Y8lww
 iiHUAd8D6rWlF/2CGarO6GnuDILAcpWBRrMD2yoVh91IgnVRVARW

From: John Garry <john.garry@linux.dev>

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 12200664ed676..4055b86c83a03 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -306,7 +306,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
 	return clone;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return false;
+
+	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = READ_ONCE(sdev->sdev_state);
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 static struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.clone_bio = scsi_mpath_clone_bio,
 };
 
-- 
2.43.7

