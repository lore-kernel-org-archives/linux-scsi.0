Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89273F23C7;
	Wed, 25 Feb 2026 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033880; cv=fail; b=plqKA0GXzOFqR3XvkrAgqaa2zvtxL7ddhMkprY5+JDjxMZwAbhxE+AN1D79BIe9I9v3iBEwiIEmvkip31GGiZGzGNFSo0XrstPpipVnnTqnBk3Yh3HqHG01HUi9LcPWcpQca3H56ICgdJZCg6EC4V8d4eaTpngV92Hd02vQR1wY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033880; c=relaxed/simple;
	bh=6jf8CjmW16vsIEs7q/Z/tQt8swzT6zCJ3cVKo/E0dLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lA6v2kd9KB/Ndvcsmr5OsJBFw9xdWAJg0w/qZfDbv7dEGkyc74C0jvHD02pmGFbkyVjf1TioikOZP/kZPtSd86ty7FhSx0U0Pi2IvnwAoctNTpMVpgCnJjwA78xoFRnKhAKxXxZhTrJvT2/Ml/QIjiyevxTFqxBvHoKSObKJAtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yg01em5r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=THzm7Zy9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yg01em5r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="THzm7Zy9"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAGx7s359748;
	Wed, 25 Feb 2026 15:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZWVK2UyXQ/ynBoWLvtfUTRp5wTBFN4aPOyFvU4jvVMM=; b=
	Yg01em5r2/NVQ9HLeNgc6fGAeIvL4h5A4VRzxBIuylcVbTHLP+RU2uW3xFIXmMXj
	6ZWkRJIDoHDKxvUCVyGfuaArTAmG1UDk0B4FF/yqhJcZFlEDt3UQNTdj9tKMn6Jr
	Ayu07+K1eRDC5jbsw2uaZkYltBtqkbDlP7HixxfTp6+7wIvxUfm86GzSHTqLMA6B
	j1HRP/3Rihxat6q6BFPB5WFrXft03cydPbKt9rpqDaDPe2SJ75pks0UGdtY2ypLL
	3jUanz1W5cEEZcOEST+JczxbQPXy1gj82MqIVFm1zztTjk+ecnPEzIcEVMgtJ5hl
	lJn10CIMruCp3ajkBn7dFA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7xfjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFPEAJ027758;
	Wed, 25 Feb 2026 15:37:36 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8sv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kU3bqsEtgtJ1DvqXm1X49B7uHda+t6Z4H3wxEHUfVbEAFihaFN852FeHXRrO4xWun6aKwq8fX3fBHQPiWa+La4lO8gH2lNu73ifnHlH+TybjWAaxpehPwjukMMFbM8PJy1corLQZOmQzuGm8eoeKNwK3mevNEKy5dMKDnY0Ikt/CyUaFcEgPfhKrnq73P3BDP3jO7USNVDvGCaVPtxiC3cvWDjk7GJztoFYGGc5pZAnYVHZBl0mSyUEwPtE9vjO0a1qRsNY5tc7+ZJjagSx4xQ2KNec2+4GASD7tnWs2+2yfysu1H9wgibqJ5AV/saLLCWbcjAkLXHBi+WKDzQncGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWVK2UyXQ/ynBoWLvtfUTRp5wTBFN4aPOyFvU4jvVMM=;
 b=gALT9CcRQXytwV3qAiSpC6d7mi57IJWtyn8b0BpbU4AlzKb/ry6q7wTLjfGHohr+BCuyujurH+j+gLNoVjg+O4gackj25umpRErt+mgaOcs8iw4Ye1LOQnJj1Ly1fXdlynpzMR5J5M7FNrDkfnxS6f+MqksjnjJr7JLdGWTI8/u+iu80WwCq/wMEEit6Qaz3GvbAsMt5nBYd8XbzXc650rBttT9BBagpojDAhoXXIsEkwLB9IAK88oOJel11h3DvG+4yviVWfIIuGBWucMK+iW23kUKQ0u8n13vtsD8R4bsbvqO8k290Obf66MLZUp2d58nSmtJB/Yg0R0LPJXV+cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWVK2UyXQ/ynBoWLvtfUTRp5wTBFN4aPOyFvU4jvVMM=;
 b=THzm7Zy9x/fb1CUxEluSwv5KGi+dFDN4O815JJXoeIPfhL8ePm5d13GG4VZD7jSZ3dD1GqP/fqWJelwqFO2Hdk61l77EeDaQwn+p6fPl/nDbWPkMwjjo9RWuhWqHZDrGu5ek+XhCMBw5eodYXs5ZhalRDGTfWRQvO45GzJ9DQA4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:48 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 03/24] scsi-multipath: introduce scsi_device head structure
Date: Wed, 25 Feb 2026 15:36:06 +0000
Message-ID: <20260225153627.1032500-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: dd619705-3707-4c1f-9f11-08de7483b034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	su7gdE9oq0KI1prPRcuLQU6cAwmMjsmyLiDrgfFa/WcLLpV+qfqDB5qL9fdlmZP0wxwF8QopXGFjdIVPkoYRx29gXYhF+bGhSBUcxFxMk2lzQxFNin2zkUkLH2UXmVnqIJ25alkcJep5Jdh3GRMASAUaYVd9wVQ4M48nSms4SpQqrN9WkzTfVJYp83B9Q/Cja65zL8phq6MbyashlxN6DL21Bbt1Lt5ZpalImqKEqIZG3mxgZp63mbD3+DfzMjbX3/tpeZx2SbvJcpNQW+d1qRAiICama3wUhUUuYXz9esxXFbCzXtnNqADruPHIsqZNmCmQmOs83Ig2pTl23zHK6eD+iLnJPxn4O8QNKOM979G0jGAEowkXexH+apsSOaCB+eBD2/MT6qmUASk70DJtyegfi8oAtoIrgt4iIEWP3GEvx9qsYsVaO7dOhYEP4hR6/BKQkXdNgghKSf9OKIij6/o37lLm5YRdo3xCVjytdRChHk+OyA8lKPsmypyzcL6V13zzKpZjLNYPZkBn4TPxoitPgsNd8Be1+6MmUyjZC46D1hUMgs7AdC5Na3H8ZVuowz0CdHzovUlzjhgLavgz/IwZwsT1tmBsxhTb+Wjl4qwSamyMC5ks8t7Y+hk0bXEBQXpVntzUWLtzykdzaKLZI1rS6z6Uj7ckLdAg76vuJWmMN4nPDUXGLbtfA7f6a8N6roEQM4ugIKBRr4VB+MeylzGiHxxYNCaT9pFa5VeccGg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZFd0hRO2TyfRMPNi7Dvz+zfR/bghSKAx1+wmNvGq4VgXrOG7BtJMcbrkWGXf?=
 =?us-ascii?Q?bU1AJX+HVtmP/lQomBJKYvzymsk6ogdpbGwlfYmW4Sxac7m//cXWdIDl2ReW?=
 =?us-ascii?Q?Tl58C29yDE0xC9kayIi754wXedtN02wDwREW2NOlR8fg/KjyrY+c2G09fLAI?=
 =?us-ascii?Q?Jdbc25XzqEXlF9fKWlquYp/IEMYPL1ZAmAUqeAyts/Vk1b/pr421rPrnukWS?=
 =?us-ascii?Q?ueMlfdsuU6mV0qEhjbqlh3/OUpmdqaufVwdMBoCOwIg4lKm+75XVYafgkmJk?=
 =?us-ascii?Q?VCwva86bOWvbINh5Pf5PKWhiMkhq3JttUT/IxPkUAJk5+fnAK+64r+K1+DyZ?=
 =?us-ascii?Q?I26j/ry7OVqiCwi/x3b2zVEf/As16AGgVJDxB3fO4YK83AiOVDcYcnHblvu6?=
 =?us-ascii?Q?1Ef1GH3lu/nL91X98d0ZDex2CIuckSJscOmYpIDKnZT8FvWwHZtGuH09yDQj?=
 =?us-ascii?Q?kwYAMHNE89DUfYFHaIWy/Na54tEGgOVamth9GDFY15mNU5tp/Dch/bwFXwg/?=
 =?us-ascii?Q?Gii0qgI1ySRCJhZTeyPB7QmCcJx93dD6ztu+9kKa6zNKmeteOwZ4i+j7ZUZN?=
 =?us-ascii?Q?Ev8dbPuKKHDnNjcT5hwFwAMUAF/B6W6YK+HAhVqkqvUZcHuJJnrGNRE43Fif?=
 =?us-ascii?Q?pV7MgWXCNEdmGiEDi9kEgFv9jS8JL+FeAWd/kbNmw/p7guCBTCoY4wabwszR?=
 =?us-ascii?Q?Lbaj2FMOc3qlhhaoVH1W39b9pYO7l4K8JG81I4aAD0NDnn2cg+8hBf4tpx6Z?=
 =?us-ascii?Q?V/3iAD+AsTCe/Gq8ZUV3ojJKyCjngTzRIdvPVYpG9q+SnidpNyFJD3RhtP4Z?=
 =?us-ascii?Q?lqlqbdrHwS1kNTqJW1jVWbMM/h8Gqru5HDQ5ykSV5r0Amf0uVlhR6inZLMdY?=
 =?us-ascii?Q?qCLSPtQ7lvWrDdqXjL7gVOScpGndk9SyHXlMB/f9UOF4B6a40tX6azUKAP0w?=
 =?us-ascii?Q?5Q1r+xxpO9OMSmPiIunwwSXFYMCoUe3qFN7lxjMOPp4Ub5wmB+5gkpfGVZYN?=
 =?us-ascii?Q?pz/05sKFK14K+PHNhEmHdfkDF/CHNxal7lW2n+qVq/r9W+qZe/D+inJeHmx8?=
 =?us-ascii?Q?UOCNWfzJ5p+WGzTtmDvvEb2quP66aKS+0/rJk5nfPXBbvXN3c9vHw7EC1aEq?=
 =?us-ascii?Q?201thakWAv9i3SAW0pM3e7hWANu+WeTAqyN9aOvnh7r1riOHiuBL/RlE7+Iu?=
 =?us-ascii?Q?gpA4JaErkOBFjV3/4m8xxu9nbexnK52kvykUUB9GIKqIexQb3taMVL+K0mJM?=
 =?us-ascii?Q?xDnR5weosMJBFYMFU7lSGwC4OOt6oA0+wQB0OPFFU3e1S5oF2uOpehKGKW4V?=
 =?us-ascii?Q?qMESWmt3GVOW/an2O4+bIKQOD3A3oPOdf6GgX9qQn9bpgyh5kxdafvnMOr9L?=
 =?us-ascii?Q?GggJVpwpm4st/P4szkraP0xR05BbTMhwnYc6SQYFOBD7H9vwimJB46bR2ZQu?=
 =?us-ascii?Q?ceXZLWdrCFVwfBnmI12gnkbTz8aHAT3d0PfEqr5TlJ5yjbJrnwcuC/CKPPlx?=
 =?us-ascii?Q?K6q4xCRG2VpEyXIY/2oDWWHu+x+yvsYi78cOoa830bTmbf6yJHAJhVhw9Rki?=
 =?us-ascii?Q?R70Wnu8xSMK6D7m3JlD+HQLu2jUvbK/Ii6h6H8i87p2SIH476NonG0TvQnxb?=
 =?us-ascii?Q?zM6B1VmdLvYGmxjHoRqFsF6TH/MlJb54JdONz14pv+4BguDpG7j5FJjmZHZa?=
 =?us-ascii?Q?mdQQqLW3Wse4UfvsVK8OUXC3ns4DltHGN1gvwU2MEFz6CkkuwNQ1c/D9QLrr?=
 =?us-ascii?Q?zXzBa7v7Jdo8y9pChHAtFsNW1v8wNN4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qzrtgg/LcmuzZ4LfSlEdK6WX4DcbELPoOeRlrOtEOtH8r6hUEd34objKx/OHa1yuDXpnfXmUXfUr5UzFNv6svPk0Y06iZZ2ZvdRK3gGAvEgZakix5pVb97grDNj0PLFLmQsQhloGO49GaAMm4dmyQVs5UUgdbnqO1aAa9Y8ZEpoc8hu8k0yahoYwb2LcpTvIpg1uPhbOpYNRzb/6IxxnHyi+9jbOy68m7ODUCamDe0ghpmiC7nQ5ls0C7a5YoVY5CQZSsKpviGFhjKoSE+xgdqPbnKuHqNRBgjAABESqrtoE3FZqlhMB637Ss8UvpYk8ErAu4Wn+fNUZLUuGDUBoZvv/yUxhB3MYKeN/qz8aYK5pcaMUNRVQbJkV900grwuDGCkmteEmFg7uEuaQymZZA+yaGPCcaZgj65XIA7AU1Pl4vrzCuWISrYL3ha5ewFeXtwVzYfzXOZ8OBXlmQmmU2vRvqPo8dPnIGp6Q7aG2QmKhfd9YCjse9C9trwqsWQl0zLwbeD9aMfsJyT1FTTEFp024JyemBVwZwurO+js0kReUJzn85rUshbmGOzsKXBlSa+kbCxNJ/A19O1s1shp2bhcw5D4ZRZnS89Cl+M6k5pc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd619705-3707-4c1f-9f11-08de7483b034
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:48.0914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIhZDglR39DXkn1kGoT/IlDPIjChQO9Fmg8dVNol24s12q56T75zoEm5m6P+z3j1mUMVma336hk684AsergfMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f1741 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=V3fetYcEjqX2rsNKOekA:9 cc=ntf
 awl=host:12262
X-Proofpoint-GUID: lpL0mAzNrb_Wliu9AD6C0kj_hlli_71z
X-Proofpoint-ORIG-GUID: lpL0mAzNrb_Wliu9AD6C0kj_hlli_71z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXwP0EW2mJmyTo
 q+2OtfEjY4jo8c/+EqVKaXMJhrrA/AswK5Mlj6i64jX9BmAZ+lMOGTpplrhC+WUXtMMONt4znmo
 W27wf3SQPZyxtvhcshPcAR4ZF5mPJxrFO/jd2mLBZ28EHsP+2sangOpzjTVYPmG3OFZP9+291S0
 oKU706zeXkORxBid+MKCTfhFkvRWwfEHZ55d9Do4gy9bcwMhDlc2LIfORHjEpMnT3qPDCyRBKhA
 cujBIZUXoi7MqPIwQDLHlBHrYU3opVB6YPpmtPDhki3cwqkjNMwQBYcOPr3i7NLO6AMctzQetBZ
 Tx/rnl9BPHIvyK0oYpujIVzdOZi5bSi6Vtauh5ZQrJA5ZlfFpRmK6lnZF6GtllRDor4p+NrAUhg
 QpKBKhD8DHJxL/syg4zGDqUaNcEjurQjf1bSUM1IHMMpYYiBP91ZpsStUC05wh8smDNP97GBmyj
 osv/cVoN/TLqqaKttiZ8ItixtbEKnsqvtcmHa7M4=

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
mananged by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 147 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  29 +++++++
 3 files changed, 179 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 04e0bad3d9204..49316269fad8e 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -16,6 +16,10 @@
 bool scsi_multipath;
 static bool scsi_multipath_always;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int ret;
@@ -99,6 +103,73 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+struct mpath_head_template smpdt_pr = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+	mutex_init(&scsi_mpath_head->lock);
+
+	scsi_mpath_head->mpath_head = mpath_alloc_head();
+	if (IS_ERR(scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head->mpdt = &smpdt_pr;
+	scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_put_head;
+
+	device_initialize(&scsi_mpath_head->dev);
+	ret = dev_set_name(&scsi_mpath_head->dev, "%d", scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		goto out_free_ida;
+	}
+
+	return scsi_mpath_head;
+
+out_free_ida:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+out_put_head:
+	mpath_put_head(scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		ret = scsi_mpath_get_head(scsi_mpath_head);
+		if (ret)
+			continue;
+		if (strncmp(scsi_mpath_head->wwid,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+
+			mutex_unlock(&scsi_mpath_heads_lock);
+			return scsi_mpath_head;
+		}
+		scsi_mpath_put_head(scsi_mpath_head);
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -107,6 +178,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (!scsi_multipath)
@@ -127,13 +199,75 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 		goto out_uninit;
 	}
 
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	/* scsi_mpath_disks_list lock held */
+	scsi_mpath_head = scsi_mpath_alloc_head();
+	if (!scsi_mpath_head)
+		goto out_uninit;
+
+	strcpy(scsi_mpath_head->wwid, sdev->scsi_mpath_dev->device_id_str);
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret)
+		goto out_put_head;
+
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+
+	mutex_unlock(&scsi_mpath_heads_lock);
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+
+found:
+	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (sdev->scsi_mpath_dev->index < 0) {
+		ret = sdev->scsi_mpath_dev->index;
+		goto out_put_head;
+	}
+
+	mutex_lock(&scsi_mpath_head->lock);
+	scsi_mpath_head->dev_count++;
+	mutex_unlock(&scsi_mpath_head->lock);
+
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
 	return 0;
 
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
+	mutex_unlock(&scsi_mpath_heads_lock);
 	scsi_multipath_sdev_uninit(sdev);
 	return ret;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+			scsi_mpath_dev->scsi_mpath_head;
+	bool last_path = false;
+
+	mutex_lock(&scsi_mpath_head->lock);
+	scsi_mpath_head->dev_count--;
+	if (scsi_mpath_head->dev_count == 0)
+		last_path = true;
+	mutex_unlock(&scsi_mpath_head->lock);
+
+	if (last_path)
+		device_del(&scsi_mpath_head->dev);
+
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+	scsi_mpath_put_head(scsi_mpath_head);
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -142,8 +276,21 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 		return;
 
 	scsi_multipath_sdev_uninit(sdev);
+}
+
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	if (!get_device(&scsi_mpath_head->dev))
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
 
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	put_device(&scsi_mpath_head->dev);
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
 int __init scsi_multipath_init(void)
 {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0d69e27600a7a..287a683e89ae5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1447,6 +1447,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	} else
 		put_device(&sdev->sdev_dev);
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index ca00ea10cd5db..38953b05a44dc 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,9 +19,22 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 40
 
+struct scsi_mpath_head {
+	char			wwid[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	int			dev_count;
+	struct ida		ida;
+	struct mutex		lock;
+	struct mpath_head	*mpath_head;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
@@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+int scsi_mpath_get_head(struct scsi_mpath_head *);
+void scsi_mpath_put_head(struct scsi_mpath_head *);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +69,16 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline void scsi_mpath_remove_device(struct scsi_mpath_device
+					*scsi_mpath_dev)
+{
+}
+static inline int scsi_mpath_get_head(struct scsi_mpath_head *)
+{
+	return 0;
+}
+static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

