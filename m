Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEB3155C93;
	Mon,  5 Aug 2024 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722857626; cv=fail; b=Y/DsRvYHPDAhAwm5touTRnqsa7CO+YAOxoqwbxZlgmsCJ+DsUkjeNaUtFgD6DYV/i+XeXh7jsGpIBZ7kirxf5MO8fJMCzFbii4P6d9/MMkx2XSxPYiEa1sI+lcd5tu2CxHNrPSz59Kkdw+aW+PeuL8/PTEtvVg4W3FVcGv/OBd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722857626; c=relaxed/simple;
	bh=SmjA48cBWWlot5fjeV5M26kiQ5R/zGIk/sYfYmddS7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qPC2L+dCiyGZ+fpLS3nZNHeH8Fohum24zVQNGQWoGQ9gBKn3waAEZCmwJTPIKnKMFwxJZ3+bMdpDmE3Htlb4L15ALctRytJQ4TvdgG64xYzoMHQeJFhDSZl7yqfK6UtIA2ymAvQb25NaPKDrqzPsfEQkb9AMN4Jcy2WEuaMRT/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IZIdapLU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jwFfSkYb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IZIdapLU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jwFfSkYb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4758fWuf028157;
	Mon, 5 Aug 2024 11:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=7YFOafPWDlLkq6ZA6FFHfSeEG2rL5BHnudcweGn65lU=; b=
	IZIdapLUf+lyOcsDjlGgjqT3dhR8rctJNXg0H+Vbm+81khz1aPdcubDhIHrEX2Wl
	C5bfPGHt4rctqui07OoUcOHxu3UW32+kbpYy+VG66q8J+KMtI2nkOXSuREveEAVA
	SibbSWc18w6fYwEOwHILLJ3Oei81ZuNCPQkE3OuqCFM9EDCsZrf+7P9ZofSHb8hE
	fp1pnk8T+WmR/VQKdfDbR1beGmfX3Sa/enElsi3C2VfNJC1gln2Wd5KpYVPs940G
	k8xmWI0UdQnz2FIyJLNWyyKSfgRk/DNM7Ce2WplshBrhoCjk3Is6gRn/HvRXMfLB
	/I/5sU7gNLUlJqXR1KDU3Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sd3ujc9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 11:33:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4759d96H017980;
	Mon, 5 Aug 2024 11:33:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb074ujd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 11:33:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBLmgllUeWrSmneUwKRIBSdUSxSMCys6dlSYe07APiYc2F3vt19pWq9j8oBjBubCrKFivaJoCeZB7Rd1Rx+6SFKgr1MT3IPvHN2mLoHufQJij5yRy+VjNm5M1T5K24V9eIYsMg1pRRr61pSrsltBblH7RenYETILPxuonLJSKWLIdyQuysOhi9T9BpFh0eJYGBlgLecXKKdJUzyOwhUZYCaFfawccs5+451miqFO6x/9I4g9BqtXKRTFl/HcBl6UfClvr5LSDrVZHuw2AF3hiwHJbBYPQv3AtTX8lTPMKQnOGiWztKBGY/kyROwzFo3c+Q3MRC3DPpThsQxgsXMdCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YFOafPWDlLkq6ZA6FFHfSeEG2rL5BHnudcweGn65lU=;
 b=xUtREewMtFTn3/lp2fVkXTg1CuIbr8w4oa517XfJ1jPoJopODNHBiElme2m5CCoTN1Am8JjQi8HvAAWPEjNSQiVWVuHIula97/EPgJmdA/VIey12bBUangnKfhqvQZbohiVZel9k84F5xX2sHWntSuFtYoqDg5pimQbas3N9ZodY3chMwVsloHWj6ij6QtFty+Cr6H8MZSybwtax99vaJ4sSqJb8uhfMEBc2IG4UiapM9Rv1JZvoeQPGqYNLrFVSACTup+/+9Ph86GfGFJ4jUnjtNEc/wHHRtLMeddxWDQswtXAp/u4ntFIn45sGJfTAVE+Awq31WHAOa1eutzfzjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YFOafPWDlLkq6ZA6FFHfSeEG2rL5BHnudcweGn65lU=;
 b=jwFfSkYbgsKi3u+LM9qgtH+mjr294RsVnLDuE04dg+7KIhnHDofVy8H7ig3Hqu/ltncfw9nKzZIwCfz/n1v1N+s4Fmgwssoc3x7PxMjOGvllc7fgVzpZVoH3X1J2gsf1tkGXW5DXifdTocYQzZLmRJa/1pu8carOc9GXQf25o0k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Mon, 5 Aug
 2024 11:33:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 11:33:39 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] scsi: sd: Don't check if a write for REQ_ATOMIC
Date: Mon,  5 Aug 2024 11:33:14 +0000
Message-Id: <20240805113315.1048591-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240805113315.1048591-1-john.g.garry@oracle.com>
References: <20240805113315.1048591-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0159.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: eb57644d-6b18-45a9-daf9-08dcb542737a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jn95Df64MIbBpoEVmQcTpd0F0eO5kgE8pM7Xe34SEKSkgT156qbdHugs9uqD?=
 =?us-ascii?Q?HDErzqTOwO/FJOxmV77iFcBSVmWZ11K9tOiiOi5myZ6iov/56E4A3dG39hsY?=
 =?us-ascii?Q?/N6bQrxnUuzXXLFGg2v7wAsLYX+u3/uIV/qSW8ywge8iOdBgb0sFmkUnJpUP?=
 =?us-ascii?Q?p2XIFGM+SFTi9p+ywwQhUPY/qSeKKbnUXT/Jlj8595hNlBXv+AaTvwEyo/0S?=
 =?us-ascii?Q?QKloV2lM84slEBhV/k00E/XCoOKWwcNMEDyMOFhFtyk7kcqVWsF1j6aNfK8d?=
 =?us-ascii?Q?krT9MuiANntP5auWqhAXB5TjtASANeUyZk5h/EwC5Lv6gexJSiJ0dmAP1Co+?=
 =?us-ascii?Q?Y4XhdyrGjwsWosee/SGmgXAaETs1vDpc8ybcJMaSQGhJ4bL2LVCv2Z0hboIZ?=
 =?us-ascii?Q?bmcBIH5iVKZG4/7S0KoedYoHcq5cvTkvpyTl7GaeftLRgaLQjD3fBYbRD1Ab?=
 =?us-ascii?Q?JBlGoX+pQVE3dYnCII7IyTiF1a7UTnSeEzWnax99HiuP0hdnJpH7RbymlKcD?=
 =?us-ascii?Q?xjDRYSdAUqyZAudg19o7USUbVb55CL3LA/DV3WKVhBkmFRpfd++4UhTj7jjm?=
 =?us-ascii?Q?33PQkk3Rrl5YMaO8KZzt07Wd1FIqXhHABIiy/bWcQqyeBfkHPW3T81LQggCn?=
 =?us-ascii?Q?VqGi1PnG0vK6fKszsPZjzs5x2wfnwulg5ygH99YJ9l+jYMJgXylZySw9RnBs?=
 =?us-ascii?Q?SudjcZGrtTC7pmKiVi9XjEIEArc83zE8kb30RqNuXrdSem2BBHeIaZBb6G51?=
 =?us-ascii?Q?Y0pX067C+6373Lx2neeFBJw43zm/nh/bHIxk3mAf623VHSSKdehpA0kegpF4?=
 =?us-ascii?Q?jnn75IcnUqQgDe62+DIosWwrfnP2/DT4mBVQk7sddmoQdakfN3yWJH39mIgr?=
 =?us-ascii?Q?rF0/P8fWGHzAJNf6N6rjBjY6UBdD30fxjgbSUyW35vbqi4Kn1dHUPJ93bgsE?=
 =?us-ascii?Q?Xa9yKgfnAE8zYY3XdDWanC4AQaIMB3gGXIlyr5DHSHLDlGqhN/xVLXpkCDFg?=
 =?us-ascii?Q?1HthObKimhbEiggwgaE6NK5hJfiWcBrf8Q8amH5Y5dY2ZObBZfeQ1HidZcXo?=
 =?us-ascii?Q?IBhgCWYLrOJ8M4RxywiVXmF+rKVK3wWPh18FCpiXdevgAaJjkKC9Eh2E6B3u?=
 =?us-ascii?Q?q+ahsdVWip6NWLGcAIrIPPcykRcFcF5QdfXhqMImrk3Z0Qh2lZdqGnYMS4eH?=
 =?us-ascii?Q?/LGWp4OCWzRrg4s9xjKzzxT0dyotdaoshMsCdeUOMSgJlLIgMCXtyficiLtL?=
 =?us-ascii?Q?O5ZQ2aFS97yObWAsdmBn12B3zFuP/21BplmPwqubvmGPo2QTg+p/EBsM19jR?=
 =?us-ascii?Q?MlMQkroSlsXc+284JwOZVBPAbHguAsFhjIyAPTfzYAKRDA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k6qDOLkCnYmOjQY4FPQCAbdkpNXiz4kkB0NUK/zFSChNLPFRsAKWpXUd6VK8?=
 =?us-ascii?Q?xOjp91GHJelYy0cr0eBT4IyzrnF1GhXdES49VexD2JiAze7Ue2pj40o4UJIk?=
 =?us-ascii?Q?2UKEGhEzNaBlVfBtOciQBrC0RDRKieFdlaIXVEoF1PPpCP5XIlgY7y9H5K/y?=
 =?us-ascii?Q?9ziBfmVZLMNmJRnvoU/LozcnAK8IW5F1yWROgmt8zYBb21qzT13JYE4v4xqx?=
 =?us-ascii?Q?wBUBeRUObLAblIunCbNKwJt0IRN95xxELrc5fyi+JkDnfA7QXZF0yjvkC/K8?=
 =?us-ascii?Q?50MrLVB+gLOekrwX5tKYkDJzrVeLsLzeOFmUo7NuT/qCGTNZv6oWs4n6UbAL?=
 =?us-ascii?Q?C3xi0n1RzOokV/yA7Q/m9rK5dyttHrZQnwX/PUoJFtJZ+Q1TtBLowKJGRdZa?=
 =?us-ascii?Q?0oLBG6uoE0WHaaofq8u4z+rwRlK1a0nvZ/lSPHfwlP5F13BdNqIsaazacQY4?=
 =?us-ascii?Q?l7Jj3mnTIDSD9HUHZOnl2+cM1t1HEFnKpwTqzflvphx3LwauQR94GdTqWbl6?=
 =?us-ascii?Q?5DDTU/bdRZbA3ugPCFQRKEWvF9SSG0XQKy8/F6VHzDYzfrbCQDHd4qIgRAvP?=
 =?us-ascii?Q?5shknPJpWMuqx/UKbKHMEK78SRa+5ggkptZ4eqI4XNqwLDrcxvQ43i4Pnl1c?=
 =?us-ascii?Q?IlU45zmIxf/eDkHFoQVRezixSgWRqLq6mqqpkhJ37Zij/ObQU6w+tRjPWx1q?=
 =?us-ascii?Q?YPRU6H+Ldhi55whjO1vlvt4MTEMwvX7E36mR/DVB0jXq0ALAmqDb8ZRr2Dzf?=
 =?us-ascii?Q?NEhacmeWeqGRaf58Spvs8FHtPo389TbR3cVz6r6It0uyDjt7+cY4D3xfY1Vj?=
 =?us-ascii?Q?YRTiyH4cmsak8wKX1fN2bhoiNUu26o+zP12qc2GHTITelJNk+zeUH9f8ksYE?=
 =?us-ascii?Q?2Nbsxw+o3dajm13NMedZOm3dfS4Rlgnnh2b4myrxCdXQ202n321InKWD57Uw?=
 =?us-ascii?Q?7CPlHkCvXn3ORjebQOYstvKgzn5NeJvvfJgCwolGXQLGyIlyIWAE9suOOs9B?=
 =?us-ascii?Q?OrkhgtB4AjAwP77dBYa0i0vLuBqabcnWWujjgaDXWVizC0bsJnxB4kquy/Hg?=
 =?us-ascii?Q?XYdVJRiPj7ETlegaC3a/+7He97qnmS7rN/naOTm04HM7ZL7cwZCxVevkXoiv?=
 =?us-ascii?Q?grfnbZUoVb6RtVhSw6JVkJWWoxIeBMmzWpMgpUoDlRluAJtRMxc5rv53joA2?=
 =?us-ascii?Q?KaZ3lxunZpTBCY3Fr+OGGAuy1zliOFgkk/aBaZxo4cAXOunztTYhxFJBuQ+p?=
 =?us-ascii?Q?++d5sQFZBO9AoF4V5a09d71wwr4BSFKaqoPrZnULEIP9ii6K7ZJsxVwQFenL?=
 =?us-ascii?Q?YXFrmMoCKJz6HYQy8i67q2Qn++Ka99Kd2vk/WCMsFvoBSr52F0FKm6r1vDt2?=
 =?us-ascii?Q?FNGat7NCRN7baHl27guU8aMRNPiUiL6FBYmSukIUqry6c25N3/lCvfBT2u3x?=
 =?us-ascii?Q?Ql1diYaywnrZqzGOc7k0ppzmyRF31k9UdaamxrSDFi3zW/ClOsGhwVxeUof4?=
 =?us-ascii?Q?mfEPC+qitNZfv/4f9rgKK6EAse8V3emMexbNpLVx3gTbpPMN0lJ9EEuwbdzQ?=
 =?us-ascii?Q?9c5PpgkPq46WLq4i8ty5lsgiiPoiskwZ65IPPJCCSvKylNAZ0Q2gQPNE47hH?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kjabpweEjU34UJVmisuOoykKxx0YP2tEdgOv2oYmNc5vjOED/TrhuIu7tLQfGPIr9RkTyfOXlq+YeIIGF+Lv0Bsq9NN1c7wP7I7AP9J28e29rWwmnOKpdqJI8LTWgX/BIg3q/hqtlBkFCvXmt4fn+f/dJ8iiRZy8u95eolYbqhyA2RXW4Qh5sOEz0Y+rbJ0zJWDO9BdRXTuO4O8u4KOQ2d0/TqfNBYza+LhQoIJ7iDKxYnXa6XmT6dpkLv+BHBedc1TSUE7pA6bQ3lCA1ipfBr3UGkRZr8aaBgK136e6ifrL7SE3vOUr3Mfp6Gm+okgQBFdYfjp722+10KqI9ayoqzg2TwxWFaw3l/SF7j4XWdzm1sX97usAH+0Q7ABeMxfsbxirzzk68v3JtRwMSKJ5c30fkJtJY/2lqdGBnVifsYiF8TFLVVg96Hpg3GIkv2iV4fKQSkK3DJ8XehAvOCYBnGsxTA4sz8RVBY0PFLM48XyvYpU+Jd/NhSMwb86BJhv8CabSnx5WHIwsw9s+wnzbUNFzVFam/7oXn+ypm35+eFG2Bm6GeuQsPpxduZZI2s0um0fmjwEmuiZSXBk5gFTLFUtfragMiV3uMfdfMpvb4Uc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb57644d-6b18-45a9-daf9-08dcb542737a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 11:33:39.0798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nxrzNJhraMwx/BVeHjtrBmJc6F8k9dz5Icxo/uhEFT3Uv6r6WJmnl546WTmiJck40TCcNLT3zgQiXd/7GXK0cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-04_14,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408050083
X-Proofpoint-ORIG-GUID: XHD2JxFRSv5IKGM35I0P8rE_WTYzuFMc
X-Proofpoint-GUID: XHD2JxFRSv5IKGM35I0P8rE_WTYzuFMc

Flag REQ_ATOMIC can only be set for writes, so don't check if the operation
is also a write in sd_setup_read_write_cmnd().

Fixes: bf4ae8f2e640 ("scsi: sd: Atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8bb3a3611851..2ab47fb50c75 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1382,7 +1382,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
-	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+	} else if (rq->cmd_flags & REQ_ATOMIC) {
 		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
 				sdkp->use_atomic_write_boundary,
 				protect | fua);
-- 
2.31.1

