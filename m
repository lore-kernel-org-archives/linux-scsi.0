Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E533D7D6B;
	Wed, 25 Feb 2026 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033606; cv=fail; b=fi8Ghv38Jht9fjv0ktNyAJIfXBK8Y543c3tIAYPCmlpsdiWW4XyEhRtcNE7xIyVuFNEdM0E08W9PpK6LAOyvN7woQOL4bLH1Wmqp4hfkcA4mzY+vfHOdKbHW58dEbipYxAIAVAS/pQ1C8lLP78TtN0NR9ijr6BtoLy5dseaZTdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033606; c=relaxed/simple;
	bh=IyfXkVWV1+zG5gJhJfQCXE8IU0z1ck0iINyc4+tHBy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GpbuzoNv+i93azN9gboE7MdlcplrPEOQHS21TjUAajAe12Z5L4H9jDFyVn0w0FVOYkI5bk6DHZXrjenM/XQs4Vmv+YZOO28a8GV5ZXxBK7zjtrGprMGhYtyrZWkGrmALHBVf/tpbkIu5iXoOd8Z6P7LedZMtv7wumItg2iMmNWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MjsJauGP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=scngdWuz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MjsJauGP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="scngdWuz"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9nIru817326;
	Wed, 25 Feb 2026 15:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1yKKH9A1e+gBfY5ZM7wVAowXnn5aqmSHe8AoxDewErU=; b=
	MjsJauGPQtaaJy6ZVbI1J2oTwJ07/EdRfiXkRKeQ45MJzMhDiT/vfTZVy06ENNS9
	9QD9VepLviLyzTH1fVXTnpCV4+EfHY9vHf3IfWZiM8Ryqgfnt7o/A9QqbdQE0mAt
	ruVjKDveot0wgDGvWnuLjxBAaK/+jADNLcmdKy46o/4VnvB/NWLs+FZ4Mddby8R2
	eo7CHB9BJ+08NvxFWSFJwa1lVYnerYIhHBWiD/N9kQKqdBbhmtGY1XVQ7LYIeS5T
	N2ZSzu6MD96j9/xz5sQNDPefH4UFFOkJRT2Zwr0xoGt/p3Ot27Qe9LHFjqiTr9io
	OIrgq0vkCoGUKxHG/2un9Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areect-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PET33Y038418;
	Wed, 25 Feb 2026 15:33:08 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35nfkr0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qt5ZtYEY6m1Y6DHUKJ4m1Vl4X3CfaWsE3DvSLT52YJNoKSt1DK9kuyqYjAPXkeK3HZV1HCBzzCcYvgxwktU+/auMFEA8WRh9DqxDXKyNgbKSTEZ/JYQBkBJHUf6fwxfI0hSTJEiGdfOzM8BKIwCzOeR6A+Xi0ItRAkF6UbEvGanmlcAe9FmFsEpThfGygyUiVKGCqHsbkVNhcm2Uc+u6PdkrvGBILm5A7jSoepDr24AfClH9OFEb+yg6czQCU9IjprhzJAKGnlsn6xTXJ9o7Md9YoBJzTurWR7jLae7nmU6BnhYicbIMfqlldP53KT4zW+JD7DHYpiXL2XbdYVu6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1yKKH9A1e+gBfY5ZM7wVAowXnn5aqmSHe8AoxDewErU=;
 b=x6vRXEBFkwVAgyZd2N+ElxSq0NBiFUFS3AkJNo4lbHMdvVNYypiz2M7kMl8/8XsAuawj//9Nn88DoQ2qL4RIb1gSjW9G7tUBIT1kiOTN8NEuJ/48VfjxPnGBS4DpqRYKey2I+BN8b6g6ZJbJkl8xiSdfdAde+OAYsatGmv7rI588RQ+kKvqVhRZ2q5N4Rznj9+qydLFCA5HmrHFfoz7Z8lo2hrH20sAVunsAAI4002O5q4l4f0bmDdFP3MfVK0VArGv1dOkbkXI/zGV2V9XWksOL2WKAo1mHiIVro10Nj/q8HBv9rWzFx0x2o5oxQ8Z8frIDGkak7H6c4P2vZCMqWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yKKH9A1e+gBfY5ZM7wVAowXnn5aqmSHe8AoxDewErU=;
 b=scngdWuzMiv7t3lBLP0hBLiEog0emCDUlQGV2Atrbyp6XszkdtJSQnKswId3KEXxFTBkhINE8fcGg1C7CDzXIyPYYdAiQrsJtH2tu7ATryYCsrlH4Adm8L7CU7aTtm/hzY1NVowDZCOSMShXkVN68RF7j5HMjPGdu/pgDWmH7cE=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5017.namprd10.prod.outlook.com
 (2603:10b6:610:c3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:03 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 07/13] libmultipath: Add delayed removal support
Date: Wed, 25 Feb 2026 15:32:19 +0000
Message-ID: <20260225153225.1031169-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0339.namprd03.prod.outlook.com
 (2603:10b6:610:11a::30) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dceb67e-842c-413a-f633-08de74832a32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	u6twwauZpRw1MIQgnXjOiMJ38duYbLxD67s8+IpcoQwCFVOE1lm2sm4ZMDXI3cGUXvd6loOU7xrOiagVIZOpomexlcyTI9sXSMjBeBALSedB0VqwnDUIeJaouXPBtVrj1k3z8HVwaTg46veXE+d7q72a+0PGZKKJum3zq2M8U76d2nKh7LqF1qTRek4+w4SlP+1hIK7hTFzhDQ3ILq4S4hYcNpn52Z5C6Tz+vwwU9pUQ0jPXipIy88uqrVX6Pmt+V9ZNab3zHuvTrOZ2s5gLcGbMBCxU91573z2+3oXMyD2trFubyKFAkJz3IInjfyoGh5iIxgFpbb6T65u/qFwNWQF6n+km/oiJ69kaHTHPwgURs+lvQr6tplCMft5hBWap3QGOheNLBL2vPE7END82W2sNKQvYLl0CZ4T7Ip1Gc/IzsA4QvsVyJM6T5wtit8be0bbls6UtdCJd01634/r/AsZxPQQn0PjAcMnHReFm936bkj8pWOuzvV93kAczEay1MlFZiVi1+z/he/qmzYI0sLUF0jp+9Zb+oq8s0vMv+mA5Caqfboh1ctfje69z5D4ZMCCXgiZFwY1LzQIK8hUvP5oxnOr7qZlLCPm3CTV0Mn2OkgV2muXydsq8EGPFL2GjFQOnrZRkICddZfaujaUf3/KfLEKI1v4kH9uG396gZ44HNkKFwmaan7UIpsgJ+umDo0ZZbp3DahGesvUuyHXlJf1mFZjoakKD3QMLfNC9hZ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g9fTCJUm6rPJA0Dw1iDSgLC4k6NDb4d43NJWdMFQQZeWxizkZ+keOPUYNn6p?=
 =?us-ascii?Q?20lHC+V68epo/OSEbmsqmFr1L2o+y+xQRUk8VKfLyxRQ7qSTie7IXkQlFZAc?=
 =?us-ascii?Q?9l9j7R2+jcYRNuNnhsotki/AuNnSpCGOd+YSs9TGpDgiBIYGJVPGMCxKQH/6?=
 =?us-ascii?Q?KxJleibrYT/JSQqOrsOY2TpZQD46j8UVcYrI0gk2BdXL3JDyKBoye3gHTqWq?=
 =?us-ascii?Q?5CL7jEJ3e76yk91nH0TehIVu1mxdJQDhZY18eOqpGT0xIdWirA8yfPp1ZMq5?=
 =?us-ascii?Q?Xe0c3gu9n7gimH+WI63JzNTDR6DfRBi+riRrUcqlJlLjgOSWKhFVFYNs5c1t?=
 =?us-ascii?Q?qJqpI2aSpd5E4v/gwjPFqP7qxHO0QZVEy0CEOrFCNXKT0oHCtC3iDT9Rcxqn?=
 =?us-ascii?Q?SwgMwK7SZ+HIsf+JW1hYViLUTbM/ITdFm14z8kholykBBUz/Fvh7EEwMhLsF?=
 =?us-ascii?Q?GWu5TA9APrM+WZpO7/EXKAOJ5lSGw25lh73G+/AviYwv+avkhobxvfY39po8?=
 =?us-ascii?Q?BOTde+eBg4vTi2eyjnbh7Ip17vXoOtsZF2wDcmscuuzVwUg+JnG+RWX6is4d?=
 =?us-ascii?Q?l38QesCP+5VW6F8Nb3Ne34pFIRsTYtxutJy9txFI9MK0SWm4IJXqILHK5bp4?=
 =?us-ascii?Q?Lg215Sl1xwynEMoTSB6yEqWekrtk92J0mLZ4OP5/E0I84/GZLHvCUMgELPS2?=
 =?us-ascii?Q?GyBLdRIYQdjnmNTncTs5lYJO0PcE2v5K6hR4YmDMBR6jud90mhsUBzd636Fe?=
 =?us-ascii?Q?x7+id4mnBsiALDm0aK58lGFWhSY8aZhLA4bI93EdSVt+dbQft4W5k1mpS3ve?=
 =?us-ascii?Q?TIYpmOB1suoru28ttHLqZp4zBJpuSeT5NfT0Meg13/di3yItmniz7qp+3EZM?=
 =?us-ascii?Q?2N6rRpwgMf3JBSpgFIo7JK/4ekkVHNLf/0vpeTm2kdgc4eJGmSUOfZPz4HgC?=
 =?us-ascii?Q?19uSYAj5nerujqU+vQ6NFfeOyvlFuWgPBRHFka66qWC43tsj/R951EspELNm?=
 =?us-ascii?Q?y4psXUuSndVdQxDp0eOh+dEyjkA/Cvbw9fpbQq5AHPGS/C5rA7bszep+3My0?=
 =?us-ascii?Q?vj2bM8/oUSgNUl0bNeQzO06usYCGUoYKHFfX/6j6P3mDB6qA7xa0xhrLNW7T?=
 =?us-ascii?Q?V6h0Q4a7+9BtVvGTKWFfSGXwV+oPBMY5u8dm0ya7zrWuBqvPcTAzdS9mTbZO?=
 =?us-ascii?Q?Xl5LhrdXH9vtPiwUQ/F069W+wCMndsY/2jLgchPVbF8sR7i58LEvh4dSjISE?=
 =?us-ascii?Q?K/R4cYhf5u2WSG/BNa4t3p3ZA+QAWiFgOmxyh3AQLrpT2nAVQV+5sfv+bxZ0?=
 =?us-ascii?Q?2mCuVJ3+f18fAX1XQ4+QqHTkgYHvF7pDYhaYCWHvHxUF26HfFq6VFViVX2W0?=
 =?us-ascii?Q?dEjYP0E504vlPh8FMyGTvTwASZEAdy1SkiGbZiqLOX2iI/o5fm36nKIb8wuJ?=
 =?us-ascii?Q?nSyKmEV3sFiR4cpPiyau9VqG2jpApT4uLOnShYwIgHnT049XiCtni8redMaJ?=
 =?us-ascii?Q?hdjQlSVTeQKB0qL482xDqkRRCdgLywO4ld2AFqQ5kxTiQBwn4YerjuoiAlzW?=
 =?us-ascii?Q?CPMPkCdNY7iqoFBZQFGdTwEMEC/wYN3mYCmRc+p6juAUH8ZzkUu+hbWmfyU+?=
 =?us-ascii?Q?k6vtecSRsEa7zWATjSi8cqz/+lkItCb44dMjU3ee9VOZEQ8i3BM5VCddYZpW?=
 =?us-ascii?Q?bRLSBi+rkHQJQf8i3DDVYxvqfUvs9LRBe9PXjl0hDSlSkFX0jM5UHx3WO1WP?=
 =?us-ascii?Q?Ue0PnlsC2LRlo3bfukq0fVSe1Dkwtrw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NXLRlHsJvN/Bx34qgMmpN9C/W2CnTaqUeWgYixGAgABy7kh1IqjBi/DBgta7/C6zSm0bzL8k1Fano4cRY0CDD+SusUCHHGt5mcGqrhyECjfQJ4Pjwnb71R2FBP/uaE5FZza7tD2vZ6IQ8EJ5XFo3cqgnBTZbHglacy+sv550vt53EsqOa8FrtIEHAxFMzxAAZkZ5R2/PimGMzVdr3mRM9X1aFkvvciL8HV067/2XSWbaoFssROMSZHWJQlsJY1z7MfZ0x91OPL+vSAlkafL6qTyttB8woR28aZM8AWM8/SglVHyexPXqldpCXk55kuPjku4DGqS5c/TH2gTL+kkk0nzh8TdgNfVyC8kDknlfoqHGm0UAf1BRAtRWACkHjt1U1p8+EctJa/yBmIH8fOX6fne2YnWpqpa7FJdliJuZcXqWpu2A4xJEyCheMJbyOFmW9hyd7oeaNeX6XO8/3xu0oWL7A4GJVtD/c8ZmjUZX/yA3YzBPxR8jyQs9XMXQqCRvrInYLkRwhczqDtFziQsISt5TELG8oBHHlGHWhcOV3tOJlkofortZBfbIttVru8cMAp6gx+PuvEAealomoBDNhJgXObj7rHVfREbcUDJ7dH0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dceb67e-842c-413a-f633-08de74832a32
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:03.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jatfSxVZSH7jrTZbMt2TfCyOsJvc87PDFAjfgBp33kNkYa7nze+vnJLCTmHygJNT/Dr00oeKzR0A7ZLunv+Z2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f1634 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=1SMYhA65fyZpU0ymjmgA:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: mbOkBvaRnGJC0C_fqaPs1ttaocR438OA
X-Proofpoint-GUID: mbOkBvaRnGJC0C_fqaPs1ttaocR438OA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfXxvIp1YiGmf0r
 Ok1mvtZogqVVW7t6ARLBh3vP7JlOjzdshUATblysytx3ii8PK0GlfazC5JalL1GNYnDTYjbAUn3
 /R4Z84EGD8sT4AFXwNUE2mIN3CeApqoi2aL+tCjPndsbWNvFjK1RI6oJi0WSd1ITOaiZwZEjWO1
 x+t1UoMrtwIcJ/IXrdo5FR3vApvQfMCuUg8LyRwv/DOf+nKk0kV0Xz1X1AMX6w9A6r+wsB6ulSs
 AXTo9vjSqcc5Eq9KJ55B+kzh0T/cJxBYHNmlS7YtzmDd5ciI0uchcNGTgxEZCvkAvnUMwQtXlas
 dErAbnegoXANU5hpgNl7FY1aetcMPXts0W6igQMbMe8EKSQ96OUCLLuh7+ZjdDwg1pFQmT5jOz8
 riCz80+2Jq/eFgX+3q5hix76InOvuEcuCqQxrP18r33MSo5wjDXk/LD/u0TIuTak8pODxCUKyEb
 J5/6eo3SL/QTjkSYXxXB+GdHvUNYPxyqjLblmQ54=

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 17 +++++++++
 lib/multipath.c           | 79 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 0dcfdd205237c..f7998de261899 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -66,6 +66,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -81,6 +82,10 @@ struct mpath_head {
 	struct cdev		cdev;
 	struct device		cdev_device;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 	const struct mpath_head_template	*mpdt;
@@ -132,6 +137,7 @@ void mpath_put_head(struct mpath_head *mpath_head);
 void mpath_requeue_work(struct work_struct *work);
 struct mpath_head *mpath_alloc_head(void);
 void mpath_put_disk(struct mpath_disk *mpath_disk);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
 void mpath_remove_disk(struct mpath_disk *mpath_disk);
 void mpath_unregister_disk(struct mpath_disk *mpath_disk);
 struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
@@ -139,6 +145,10 @@ struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
 void mpath_device_set_live(struct mpath_disk *mpath_disk,
 			struct mpath_device *mpath_device);
 void mpath_unregister_disk(struct mpath_disk *mpath_disk);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_head(struct gendisk *disk)
 {
@@ -150,4 +160,11 @@ static inline bool mpath_qd_iopolicy(struct mpath_iopolicy *mpath_iopolicy)
 	return mpath_read_iopolicy(mpath_iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index ce12d42918fdd..1ce57b9b14d2e 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -52,6 +52,7 @@ void mpath_add_device(struct mpath_head *mpath_head,
 	mutex_lock(&mpath_head->lock);
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
+	cancel_delayed_work(&mpath_head->remove_work);
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
 
@@ -356,7 +357,17 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpahead->delayed_removal_secs" is configured (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
+
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -614,6 +625,29 @@ static void mpath_head_del_cdev(struct mpath_head *mpath_head)
 		mpath_head->mpdt->del_cdev(mpath_head);
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+		try_module_get(mpath_head->drv_module)) {
+
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
+				mpath_head->delayed_removal_secs * HZ);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
 void mpath_remove_disk(struct mpath_disk *mpath_disk)
 {
 	struct mpath_head *mpath_head = mpath_disk->mpath_head;
@@ -711,6 +745,47 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	ssize_t ret;
+	int sec;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
 {
 	struct mpath_head *mpath_head = mpath_disk->mpath_head;
@@ -793,6 +868,8 @@ struct mpath_head *mpath_alloc_head(void)
 	mutex_init(&mpath_head->lock);
 	kref_init(&mpath_head->ref);
 
+	mpath_head->delayed_removal_secs = 0;
+
 	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
 	spin_lock_init(&mpath_head->requeue_lock);
 	bio_list_init(&mpath_head->requeue_list);
-- 
2.43.5

