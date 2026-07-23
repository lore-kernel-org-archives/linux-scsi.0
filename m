Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DDB42BC2E;
	Thu, 23 Jul 2026 09:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799455; cv=fail; b=D0I5l0j0IysnOXRZozeYdUhJKIZ/PhRjNXPT72D9eDsBznLQi12q787rp+Px9UWcMBS1FjNYAzpqGmPFWDeUcEwTz9omyJKSyTjNi0SIWvzYAOVhi3Pto/jDgKJyqWB4bjCibIsxiMG0MsfYN/pctv7DuD04HUOMe/x7R1v+PsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799455; c=relaxed/simple;
	bh=2QLxqN29FI/4LUUcSZawJ40G58ca3Kr+oljqeNyDz08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QxIWbqTPlIVTN7NaY6ZfHrS2Lx9Ga/BPczxEU7X/NJ21GHk5rpsatkfh/GLeHeXsubsllJ7WsZRRMFR9prI7cigU+sBsc0ZN3cHh+N93hakhJVsvmQSitXg2AeRmFrkX6uvrH6rt9mGsCtWhDV3iI7P0lej+um99QNmbM/Wyftg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kzvA3iSX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SaXra/SN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kzvA3iSX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SaXra/SN"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJthrM3360515;
	Thu, 23 Jul 2026 09:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8FZlxv8JREh+OZB2fliujlWhEUUc6aNAhIl1RbwmltI=; b=
	kzvA3iSXvnLT/2hCdrJtRF1GWgZGokP4nKHCAtIsd+b4HdESU0edBmB5/Rx5O9cV
	49+h79Z+F9nB3YllKRY/4eMpKqyZNsuZvzEjMRNKk02qLjHKw+lyDmCea7wKfrl/
	UknlCGoMeyQNywAU6xeWXkcjBx2efMTPCRV2coDyEqB5QbUn3RkS5U/gmyo0Di0R
	TilwWU9oEOqBOdef+BnoIYNNkCLTno7SYfvlWnUX9fCy7VH27wvKtM97MHLbCx6m
	ggih1XOQ41BpoSu4tl2zPrAkyEsUSvT5hSUpaVKkiQ5Ox0YB4JqeFUtFs8XhUPm9
	333dlk1dcF3swQOP0niH9A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6muv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XYno030082;
	Thu, 23 Jul 2026 09:37:09 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs5xfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugdNFQGnKGCS9j1ReHj5FQNdfIcD0pv6i9aJkzYBs5ssGACskzmag+yP7dj718Apby9yJxWETcIsAjjyQ7pn9gZwJYs8NOluIVOzZrVx91V5yJ13h3Cg+/AeEgdqZqNHTYvd7HaCCMwSpQ7E20lkp9oQlfVRLIH9U9m6KOTWhR+Wjg5OnR1MA/zC0DN3lyxPNmXsT36p94h6J+tuQD9u70loilvsZ/0VSWX6fPPwPl3/Yi2PBBrzIRUR+pgqoBU+FYUV/KSoFbSblCGSl1dIt8xbKhVpHY8hl6bdjMvJlb4JMdCYOF5YJcGvm68weU5x4KFtuBSpbGdgfdpx3tHTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FZlxv8JREh+OZB2fliujlWhEUUc6aNAhIl1RbwmltI=;
 b=iSFuG1v3Uw43mjd5P5OB1FYxHpatkXHz/hevPP7wGX7ygx8V6junbWQbICAIw/5W0xDJfX5wjRTvZGjjFUigR7VTB2Z31sLEIfER7K48q0xQddm5BsLVc3oWBCcIBS2cS88Hc6g6Pugq5tEFniMoR+oqs5Q/OFtxJDSp/l8o+3zDkT0dykwF6pcQ169Qn72xW3dDVhy6auHL2Kwu9nr0uoq9clECFydi0dRkXBM7+IkKNf3WJp/TQW/MlIsjOz/6UFCtp7qYB68uBZw1fvSwqyPMKiCnbzPdBw4pCxxDFPOI1L6a6JaaZQEbFuznl6nivBBRsvHiOb/StUdLAeBLng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FZlxv8JREh+OZB2fliujlWhEUUc6aNAhIl1RbwmltI=;
 b=SaXra/SNnLV5+myNMFeDB4tp2be9ceyV2ZDJTDp1T8i5xIvH6ErMAekjGhHh7L6yOg+UohS4vDV3PzDrumM6a58X5UZYXpeGEyK1O3X3qmZHO7TIS5Vcj4juZkhUudBFRddSQg8S6/6cH+F4xXP9pN1UHbZ+EnWV5NX+WiQFKSo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 11/28] libmultipath: Add mpath_bdev_get_unique_id()
Date: Thu, 23 Jul 2026 09:36:09 +0000
Message-ID: <20260723093627.2327456-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5P221CA0011.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: f8ee48c8-84aa-4b7f-3507-08dee89df51d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jrYMJ6APbMxikSw2jOuHrH2FISGriFx1dU4xOiMkdsgA6zkSN/E6iEZsXARbVMOQF1w9xxnpONci2wfNsSu6WpHQVl5V1EKKKFmXlhFXNvOmgRh4SxdPtM58nrLpf7i7uwQFDRBIe7gJkr3S4+dR0nI9CMp2ubNS/OHbv2X1IlklYhdx4STHd4o6r6BBJRIenAi+a+T7zEgoWKXL+Yl4LxzTZJ0iTk3a/zx/inIDh8035N2kCRTHG8F5QhQ3oxnjJ4KsXlTAHbdPz0rW5b/rnMAbQaSEWtLh4y2pjwnEMT39vkzNwbMJNY/BxdGF3yNqDZh00esbJ/1uGBLtBVzujT4sdKJUqKDLwlkkGgZEI9AX1XjioCvegt2yiQzCsCBNtPJYzbEKFRfMwVY9MOsBr6LKNwALBMBHQZOCGB9kXSylE9gO2op0eYGg96AhJDOkeEjHJwXMTW3ocwtVaZfGdijONUCY1yqqGpOk8PZRQlAl471YsdKgqcT9JN9sp7iKUvcdEBNgpsaw2lIi3j6A0EeRt+t4Rt/95Kh4oysjV1O1mQ6tqJokeYVqTbUDfVZg9JLsY2KAFtpO+gbUGn0U6l9TZESb2+BrRHVcy+k6IV+9J2wN4mheH7Q4yNuv9Bba435mBMXR/v+OrTwM1AgyrzH1USwgfkHnUg62wVTnW30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nVEGxdRw38LFTjOECN4MYpfwAae9kBp2HN60N3ZyA4cAf7QMZlKnk5KLZ4mc?=
 =?us-ascii?Q?TluBwfyNM0hlEo0RsTGsdwsUEyxj24qb2Z/VQH2s3187BT1rCWG9c/dNfuMr?=
 =?us-ascii?Q?Rimce2PYS7JW4sgqsQaJCGPr2oWplw+u+HvZxQrKlGBsYH1DbYSnxHQoncoM?=
 =?us-ascii?Q?6+VifRu0wxWBeNTkkMuWK5BIEqVmDIJaiHJIqxP2tKbpVARXof9rh7hp7W5Z?=
 =?us-ascii?Q?XKRkHV+Spx6o8WVUtE7Pym3oC5reGj49XWIYDBtX7JG3LrcUrtLcirQdHUj0?=
 =?us-ascii?Q?wubmSnvwad3kSAybAhAo8Ducac2mQJBkx3I9W0y7O6PJoLsr/jWX9XcM72cr?=
 =?us-ascii?Q?7ZzoKVVe6hYE69KTte0/oM+Q5DMAA23TVwPknnImBFafL+lLjFaPmHBttf50?=
 =?us-ascii?Q?4YMOXGZu4wPqVwVvmxkGUxeIegzA2C6MOAsDPak8G8JJ9SiPWld4EzjowsBF?=
 =?us-ascii?Q?8Pt35PmWlG3UgfKzC0IEh2Fq2op5s3AyFm/DjmlbgfHVOAS07AS1HnctxXpb?=
 =?us-ascii?Q?hebf0AYRcUz2kGGvoPCc/K3Cdc+SZFvbWIabvVt7ULInlsIF4Yh71M8JEV3Z?=
 =?us-ascii?Q?jt9MYU5Gn+08X1zL4f4Wy0NdZRtzm97BTRXuzbp5hqZK0dKgyjfcQkf8j6u6?=
 =?us-ascii?Q?9ctIAa/x+PEdCGjJH3COYtMLj4gC5unbZSaPIRkBlk8mCuqawWSY2R0Qq6D9?=
 =?us-ascii?Q?wIc8CMLw+AFrVkJAu8isWf5W4bTMrd/jDSsPESX83fCe6P7VCrcBjT2dbsg3?=
 =?us-ascii?Q?cyTZmFH64gQDMUXtK8p9Lg6KwcfDDzZpZAwXQzqzbwiBDr+GbYvmfB8F9auu?=
 =?us-ascii?Q?YphnBX1wS3hx1sqLOA++6VNvHUmSUc10d2wSdB8D9BFPngobBWCueOs5HP0C?=
 =?us-ascii?Q?7OGnU5VXrvGItNzeJiK9O76gpu9XDVrhGerhWIpUgmXSsc7ImYVv551W6Qm8?=
 =?us-ascii?Q?bqM8iX4SMT0hbmrQkFsgJ66TlnSAwHwXxZjSMTKK4e/Aay21L1gcDJLZfngD?=
 =?us-ascii?Q?5gO/FdXhuwWlR7P8FEBkvNSiycy7RUYPH1RpyiQVeJJKTZ+qF70gaaCJrBPR?=
 =?us-ascii?Q?HKA6At/dk/ji3CVjD/5PW9LhhtgCHQL0Wd0Hv03nOdSlgVYWxwmET6LSEs+S?=
 =?us-ascii?Q?r3R/eOIVdBNb3dzHFqhwSxFnnKW+RWYSUfsB1Oh3XZ2mdOlsOF3gdgklJtep?=
 =?us-ascii?Q?gNfQPqGiK9SqoREENdYaptVCBiy1gd4o0KJEoS9Rz+cFCIISwRXgPnTWNR+k?=
 =?us-ascii?Q?uLH9hqz3Jf1TD0YPILEapz3BEH5WnaBydXljxD+NUQK4vXBHcaWItisq1McK?=
 =?us-ascii?Q?f8RsNUDE6QOshmO54406aY7cQusmIM9zF8KBpQNW4qRJEisNmodfAZOPguPw?=
 =?us-ascii?Q?X3IsibCP6FVELmoV+K79jGAw2bj1RrHk25vQKqzfWZuUok9Qh8ib0/6TXUDR?=
 =?us-ascii?Q?PoE0A84eZbzn1ODkCVD+6yRpT1h/z5tlB0dUnsTrTPbMRSPRABMnL/JHPFlO?=
 =?us-ascii?Q?8SBKGZ/HNXnybflb3uQMWsR9FLrEQoxPoP3G5+g59utD2Df3kH+1wDU4Uu9Q?=
 =?us-ascii?Q?+kOrWPT8h3u33SlO3rg2h8++o/Sr4uNPSCaNmppZdMykBKZqm0E6f/STd3o7?=
 =?us-ascii?Q?z5fSBAMmeiF/LygPmulnswxRaqsk5DWmqjjSKsPerC/kqA4qTzJd5LtfYSsB?=
 =?us-ascii?Q?zzAEHEiojN7kC3OIc1RZIZDkI+BnEZf1pcqUvKc++3pS6Km/vUWVIxW8Q2DY?=
 =?us-ascii?Q?HC7uLxw/EQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	EwsJ1RP4owXj3wWwsUobuVbapP4GAMBkaoQHhe8PzP7QYOfh5WzFwQLF73pTDeXh8QmdfrG8lzxgyfx588/+DEZkZE1pScORqJs0L12aq/b1uVQ6UzjFty7F7BcdZmXZ2lPlzusViSGleWTVMO9Hv65CzFHL+a6ANheWcfO0tL9/GTXFKnMnl5vVf2smRM1f2jroULre/4YanjXzgG335jud7IT6O9VyM2FYDAVEDd2OXwgNCnS1c+4Lu4yrOh3KinLK32ZnwQJ9asvWQlq5WyQt3Cc7YX2h9VII2zy5qjew+h5g+sYNQjnZgF/7gb56fhUWrjuJq6QKkkgUnlUzSg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bh+LTJZ5MmhEg+8OIxOJ7lLWMtUskCkztVvweY/Gk4816v+1m+AfSLFcAn8eRqUVVA1vNr5tPU1IRdeAmktYxNWH7++ZV+Ds8lTBfEIGBr2DitoN+7Miw+VChe6PaSM7jsRWUFOu/zbksTwhM8Puk2C/9uYwUpkMRbAe50r8W6t0cLD+zQB3tkpXr3KTCnvcV5CIfZ1wOhB1tZNdvyZ+0Yb8ve0IIMAAaZbzrDYj6YDP5nviiY3GEdUU5QqSXMS9TNaZdael4Lzn4CSiaLE9KwrFEsmoZ5DkSVKPIW/QNljGGJUoGGuJQYC7qeyGAj04EqSZnQN9Tr0ETuTR/HyWUAYf3HFGIbVeYLzotZgg0CZA5VaNnwgF3HT8I+aYvTy2gwkgdOV4ooB5X/J759qcFOQxGjP9YdbhImCJz2HnjA3q4nyC3/uU+6FW8Cqq4L9b7I3WaOTKNFLFXrAWHbGmXKRxK0r33LPztrksqysiE4a1solno/mtdwGqzMVKDUAT5E8cWTlrbQrIo9vXC8+sBpP6rvAImOp32eTXpPwzdxU0QdXD+khEOC+4qqJkDPWzaHnYr7FXSffcXsT4zXIseuExwRy2iRd4bRh09Nt3qI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8ee48c8-84aa-4b7f-3507-08dee89df51d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:05.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7l4AjMt1T7O1oGTXWyIEKwNI8rrjhzMGxlWupVbrM7JxsLfJ3KGcBLZMD6zXSnaV2wSRx5c6AohBLiMBkaWh8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX6GKtLedfzI1y
 dyXXpMIGACTi1w78Z2gJyOzf0kQkFLZm7xg9Tm4SWmSJZdYflmhFWFGvhjjO7Gbd21fPi02q8WZ
 D/ycukxIu1wyOj6NE5CyfiRiRVktsl9R0BVXZGlzS8YyKIXRVxgkJ/Wp1oBO0S4DRBiAEZD5pPs
 nJ73PgGKRkIymZdzzXwJVuK6lXd+zALbFOCRKBK5VEUVlXp9oIc3JCR+FnHaLP9ZW4uE51SYpZ4
 y+S3qCg3HrIdrF3qHB1xKN3Pj/ELgd2gAlnWdDGODtOZyvQR/ZtgrkA6GJ/gmh0fqgYekBetaPD
 N0YOWqbJD5WS7gs4xSth+setwKYNcHhCWxXQuh2ZVVnWSjwNFUg49ha7kPOrd3UNvRcp7fj9/vb
 jexTIJNQ0gaH0nZ7DjNtvqQh1iGqNkcSkwBhhfHJvB3KAwVu657uCj6yh+77UregWDGggkUJv5O
 Wwt0o6Lq4c6+0eqb3HnFuQXGKElktddPusIcdzsk=
X-Proofpoint-GUID: z87inY--TrvaJiyieZyfjPKXCU72aBHm
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX9xwWHKuiWy2+
 JNaGpd718U1ahX/E1ac2EoeMlPOoJlWAFlAmCpzYdKsiuZMEkGw0hbTVXjXPBuWNsGYXw6kewkn
 wRfo7sTFag7He8WSfzk6eH7TpwKP/zX+HegB/af6M7MehudQMa17
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61e0c6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=9Fc21ttQGwgXjhTEdUEA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: z87inY--TrvaJiyieZyfjPKXCU72aBHm

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index b90d4827963ac..858801d052ff1 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -478,6 +478,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -536,6 +557,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.report_zones	= mpath_bdev_report_zones,
 	.getgeo		= mpath_bdev_getgeo,
 };
-- 
2.43.7

