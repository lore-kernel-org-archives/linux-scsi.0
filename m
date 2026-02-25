Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE723D7D64;
	Wed, 25 Feb 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033851; cv=fail; b=lfQNWFqOdhMzRPS84ZunVlHlf+T09wwkUEPAL4zTM3GcaSMhTbvGligfIJFDqx8kdq5SQowcfm+rVV9eTh4t7MKhUmSZN4aEbHtaH+dVNTTrnacm9oS5Sbm0QowC43QGrGa8Rv8QmdrTsKhVT/1n93c5EDPNzTY8X6nIMa+jTTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033851; c=relaxed/simple;
	bh=M9f2JMNcnPvGovj3f0uUmRZ+patK3ZApDofVG2g+niI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c/9kAH9RLeknONsjDsqrCsfCUmOzq0ne4CPgLcO39c63NxScERpxbJWDSfZbVjncNmryZLnIfeQ5BGOWu7+xtDFhSZ1KFp8rcGXDe+FlP2b75VkceU2uprvidwN6fyWyQ55CEDcqTwwR/fE8oZvy7uWt9Lsi5XqiF8gbNGPHhRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p/wYSpV1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q5f0BxrD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p/wYSpV1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q5f0BxrD"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9Bo7P817620;
	Wed, 25 Feb 2026 15:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DtqhfLs3eujlV6Lg1rWSIchsQM/Y26e0GjpkFciPv7k=; b=
	p/wYSpV1u7Z93ziGAODox6URKciaPlSZ1/FKAoz07yMD/pm+6GomluFr7Us7qfa4
	bFrfJwczJFKhT+3QcCduCzMOA1SETbrUgYR8DLjlwV1OVkm5aMTgHnBwK4TTeOwn
	IoIES5R2fFCF9WCkBMmffvxdIyIN8c97Y/l+jVaaWxjwD5tICNWUPCpwCH1jyATf
	2bqKl4mZVUr95DIweYJtZPyJaDX+92vjLjDf1yjfLuUqaMYCMAPtILBcnSw55OVP
	USOt6w4+iWZS4vRFV6NvCkQwBc25TMH+Efddt4+8OWbOtvZJKdrr6ROtJhoS0RyW
	q5X9JA7z9ZZmHUBPRhVqNg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areeme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE7QHQ006382;
	Wed, 25 Feb 2026 15:37:07 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S68zmcslKlAmhX0NcqF5OZqxNkAKaJfRD7ERpgtyiC58GFaPuYTcrp2QkFfPsNhAqT/CxVY+xPQxtF2rNdjbTp3ZvT8eUroQmWPNun/ASGN7ShF37tXXV820bRrC8Yks0VgbvrhGVPvX25P5gBoqJ57XAGSm5eS3vY85qCi3mJXEuOgxvyDb+FDAHayelLmX8yFlZgHk4weiHwel3DTy6FMM3qMGPRrhOPYaCLiRS6X8deoA8XcrZ/0sjMF9wdfVeMPMxQ02K4WM5w1ekkp/Aqwv7xvChxv2eSkDtHkoWlxx0QpWCfbe4nTDvt1PryWLokzfA+QWaOeB6C5IKBCZyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtqhfLs3eujlV6Lg1rWSIchsQM/Y26e0GjpkFciPv7k=;
 b=DyAgK64ZgkDHajTxCUVPPn7S5f3Psx17XHYPIq8T1Pd4hOe+CWz3SGtW3tA2BSYCQoao9KldgpIe4/lQj9LdamuBu3F1fcYxpgR8gg2Hk5r7kk4VUipdIYrAIicRbzwCWvoHi6ai2Js0UwFxL1qUkxhWrUtLzrUg2TQ8lObRniZn6jmTUeXmUu/GkQOjvo1K9XKUzMoDBX0yMtmaiRwF+dAZl4PGuXRRN9tr8FMgvaNZZFgyUTjmWTKEPyYioRWVKEyoJpM+ySEDDam264JPxNVDaz2FzziSoIbAoQ5Iu7R91yduMUuovFpc7TUUUEBYBOjNzCyc+BzkLePMa1yUNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DtqhfLs3eujlV6Lg1rWSIchsQM/Y26e0GjpkFciPv7k=;
 b=q5f0BxrDX8sAeJhg102YALh7C3D4yR3LiScX9TJcPMwMwHfY8oSbTfwAjdz35BHyJIOLQBf4Q+/hSgPbg3OO40Kz7JsH9aU/RD4fdoNdbO7KXq9WnQUFx/xMX8LPd0YdgRRoukCYbhE6nyK2w+xsrLd6oIF1HcmhzPXM6zU3xp8=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 04/24] scsi-multipath: introduce scsi_mpath_device_class
Date: Wed, 25 Feb 2026 15:36:07 +0000
Message-ID: <20260225153627.1032500-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: dcf3eb13-cbca-4150-db65-08de7483b1d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	UV6z5cM3spXpT+7l3UpOg+oV7HdNrE0xmGdty223zT0WSyL1MNtsm8Mh26AaLqB9mERR0mDwFD9QwkstIWlXMpARXB/+2GRDlsaaxXGaPEuHsru7iV7VQv5nIAgmUxI3/pbYdWowkSqF9pKKdYXCOrVIf0bBf89pnO5+9Jk2sOH7f+8LMtmKcp/XOphfh0hgOitQR7dthQyOBOQ/VSgfmP6cHW7kzK8DDc+kQxQBX8kFP87EkuFy1oIwBxWPJ2Atc8gFNWwplrOa7OHfYmoszyIEGfDwh00RaVjwWA3JHdJBOvBQhpxMvZNpflDAl7AKh/lDCSVazGfoaqaB3RaSxCL1yEIJq9A7pu7fc6I6/vIAI8WU8NGTAhqWcWv6Rx0haSwUHnYxgrTgtlAvuOczzRM5pM0bMcMn8+vTwdcW2XyEudcok7qbmyHEkhdFwbpuuwxNCrFNYd+84fo7IWx+eaVj0Ka/gWsNVy5SphpWq8TbgDMoPoqD0zyT3TMY0s0wfrNaqOg34Ds7LbIOSYonJ9kp/pO8XueROu2GEXDSBynLbaF4nmSCwpJ81OXMsSqcIXMXfD737tVEUiWj3h+oHaExpmcSjysVlV1qOW1kBoTFjUyTejEAKcijB0N7lMybPvYn7QCrhs7K4hgOLpl0OW1TaDeK9tuNDRYR3G6WSPLspNefN8YYwAW8ieYllc9b6VGzaUpfVWRH2oBRVQt5ya/ME+9y1GATeyt6Fdja9U0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2PlYXiSOqBzzctsXSE8kIXKkAXLlqPhHtrBOKfZ168f3YgK9x2GBEJs3URmd?=
 =?us-ascii?Q?FH93s9zk4Bp9HzwC29MvlfSlAVdVC8YBlE1atNUIMlQIF1fyADXhni/4Tp8c?=
 =?us-ascii?Q?wXi8OA5Mnx5fV32i3/yqvF0toxbhgKdaVdfZJ7qfHp6XoeWv3fFMl3hp5V6J?=
 =?us-ascii?Q?1/7FNPfYr9JoWo1X+FASykeBYjr9BHrbDDJDJmVHg1IAYy9iAYKLQlgptRpI?=
 =?us-ascii?Q?BCWTcRUvCPlPikESIBuczbe18EstmV7mr5UlJiR51Mudw5RlADLxZFJ98/go?=
 =?us-ascii?Q?kaFUUt5DHOexttA6DM90QUCFhW+yU+yuTzljJU2iCQsBNqyXinTn/v0JA9Ju?=
 =?us-ascii?Q?jR3aQyy32S7k10ZHPj1iSf5sNCPRHpqD4ce8/T3QQ3xE1BHxIgvG8g/rz82u?=
 =?us-ascii?Q?lSwzVB7Q0jWDYLdqeBRpIriJE2hLnX9GUXrJDXhDRaQLw/l79zunwyQyesH+?=
 =?us-ascii?Q?4tOWS+7ShTMb33Ks+3Ga3U7wji9277tyQiGMfqvFSKUQ2wS/JKFa05rZSrwS?=
 =?us-ascii?Q?dQMrp7b5kJiJaaxMyasa4Jc4S6z3GUspS3iG3gWoir+PGFYbHDhJ636wDW0c?=
 =?us-ascii?Q?ZpkA8ir+wqPm+a0CiDCI6ovc8C7aSYGiSxLgRlvSTjHUK5PJxSGVFND4pA38?=
 =?us-ascii?Q?hyM2xprV7Hmn9KRFm6R+oxP5hDfXbRJZHb6EB5hjEcBKp3+5vwxgvk7pzht6?=
 =?us-ascii?Q?gLlksVogmCJkN5JOK2gFwCiUJlrqWFWGkoUnr5+aSulcjgGjnnOjalgztEQc?=
 =?us-ascii?Q?2bhBMkm4FjaKb4L6rDNO2tRSDy+GwEH2atTjfHuXNlmaUoHgY+B6X3x/evEt?=
 =?us-ascii?Q?ZJJ53cM2Y8cZPUr8Sx4wGTjPHCl3aZnO6WyrKGgrSjb7p+vVlF6aN5e9CvPl?=
 =?us-ascii?Q?JPjEzex/CXN0x737lkoBbqVnNWaZYRoBzt2kAd+juuXTcMo2TbnuJ7sW8O3V?=
 =?us-ascii?Q?26RgnmkG6ukYSjWcuL/Tij7qPY5yjpz+UT3RzZa6l5ZI+aaPQ2WKg6USO8gd?=
 =?us-ascii?Q?m0+QRY7svcQrZLNyGJvx3GIKTcLt/3LTzKiCItWTlGyPJ9XmWrKQ7i0+UmnT?=
 =?us-ascii?Q?M4NQuZtB+o/LyXIzcNkGIEgMhfrPZBf7mP6t0cbnVBiOsJFrZAvZ9+R6UYYX?=
 =?us-ascii?Q?oIhXl6CfcaQnT9al2/z1e3YK75Z3y91TBgThWuholLnM+LO3/iSts7wYMm6e?=
 =?us-ascii?Q?Pj9OrrtRJAn8cScbEn4i6kZXY1Yr8p+P+skwwaIUhtsdR9EgB2eaC7koKXEv?=
 =?us-ascii?Q?eUMVzh2k0tyxUgKZCvSMQpey4UePPtssOH5rwLD79WgzsHeQY+YUm2pbF7sG?=
 =?us-ascii?Q?pdhtRZKhxXTHQRRHVe3nPNk1KpLqg5RhMcBq9QSo0g63DOT491NDR57Dx+Z/?=
 =?us-ascii?Q?MxRWIJhqkNQsY0IksbbRPxo7pL8Ot5ibL+DWu6AsWQj8XN/mATLBfYwskdSZ?=
 =?us-ascii?Q?i3XMh5qQJLj2B6oU5tx0TRfDxMVUI2PUstF7HK3w0WqfJoAIXGDarICFY1DI?=
 =?us-ascii?Q?MQUiG622ri+uxsTxLXT1WNXkOLCQr7rrjOfkzxtn6hZiJSVjFYiZZCEAv6EO?=
 =?us-ascii?Q?R+GfMuT3ITbkt8UCf0cAykchZBC7cH26mjBJ999a3CuXC/KqIUyiZWggPzZs?=
 =?us-ascii?Q?79sgWL323/T3mBhAl6tGtWsZNgosa3Qj5mOokkKBHAoCOgY5INfJTMyop4mA?=
 =?us-ascii?Q?Y2kfLWGo+MxhOlluN8/rnfIdAez8u6b5gl+oq1WDChjgdgZCimuJijqINztg?=
 =?us-ascii?Q?LaKOuCVpkYrjcJk/GnEYhZ7+XFtK0AE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xEZFBkF1bZ5GsQ74jop8qX7LN01CrypMhAO7P2mwacWDMJFliolui9iccxqDksiVn3qclaND3akHXQ+wNfpS5bkrb+l56uYWOT9L3YaqJtFIbeL10LPJjPZl6G2d8Q9nu8/WDojnc7lwJStbyptc5S2BHhB8covvsmH5tb7yWbZ7mw0tJphgK2Cxxc1MIKduVPZDN52sos+WDM9gt0Q8GYRAA2aOcfG9YMEi90rhGQORx9Y5+mTBTmardyuDfpUIWqdUi5+3pQZ2ia3n8eGakeocDzpjyJdcizl15VFSkGtYU2ECTZBHdUdRxL+ztjiHpnmq4JzTUqZYziGYtwlZozz7A/d+0qH1RuWNz8b8YUwpV4rgzSlKGY1i/MUdk44R38pX8ArxpJih/dl1OrHXnq7nqm6Zl4gt5T0n3p6YkHAVeRDSGWLVwKdewCEkKML05NktD8Cno+NXJWeOhkJaVm9hiBR36LXoevDs0omNCQXT5ssECCvIRrp2G7teox0Qp4G0KYmSqJEdJP9cRU9hXtJXqp4nPOo8Eia+agiBI5B1xVtvU+xCCVGqaAxdXk4lwLsr0yD7MyiQAENlSD1LIuWo6IgGvN1Zl9kRCUjMyuY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf3eb13-cbca-4150-db65-08de7483b1d6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:50.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9/UXK5Ck68tBmWYuyvC6hrEOZiTLIwF7up2j6KO1EDm5mIK2rBEXS/Qn2ncIuJpnoQk7tQFT5UpUosy7QT9ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f1724 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=rhLSevvXLukHn9H0kpkA:9
X-Proofpoint-ORIG-GUID: VuC59FH85PFT9ogV9ni5jTZewRrBmy7M
X-Proofpoint-GUID: VuC59FH85PFT9ogV9ni5jTZewRrBmy7M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXzBLvCxUrKUWi
 MN+XDzbl/9tQ10vEdlabb6PVKXusexGM1zmLdma9mXHxgspFory+8M9ndmy+1wxC7n81TZs1w13
 vzWopV58BNh6pTN+irJ22oLb9hjns/VdvQ0YNiJ6FRTe2pteoXJ5+aM2Gd+0QYXuU/AVOWDYh/w
 2pvto4al+I21mliKSO4h3FWDJIptrh6wOyjfSLXUWJ1r/fR9D68xkLpsqdJ6MsX4OeCPVL+q1T/
 +bd1jQk7vsbZX3YJxe6RzxzPByAB4lvNH/iycJZWvJ9CTSzOiUcImJilSvpZjf0WS56cLc2OdH7
 8T0H+gD4Nz/xsNo1wNJO2XAul9nGGmLOwZfcpFIZkTh6MvC6BRiTQte5geqGLwNYuD7nKjSVImb
 lcYgTZ0zEzwX4CaaftDQGNnZy75LlgOOFdzdkM6WVLxtV94mwZav3OcGGEtpAkmElEJlYRX6WQa
 E6lYRnuWNwIqyktsoxQ==

Introduce a new class for multipathed devices, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 11:56 power
lrwxrwxrwx    1 root     root             0 Feb 24 11:56 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 24 11:55 uevent
-r--r--r--    1 root     root          4096 Feb 24 11:56 wwid
# cat /sys/class/scsi_mpath_device/0/wwid
naa.600140505200a986f0043c9afa1fd077

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 67 ++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 49316269fad8e..05af178921cb4 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -85,6 +85,69 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_delete_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+}
+
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	scsi_mpath_delete_head(scsi_mpath_head);
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	mpath_put_head(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_wwid_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->wwid);
+}
+
+static DEVICE_ATTR(wwid, S_IRUGO, scsi_mpath_device_wwid_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_wwid.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+
+static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	return false;
+}
+DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -129,6 +192,7 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 		goto out_put_head;
 
 	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
 	ret = dev_set_name(&scsi_mpath_head->dev, "%d", scsi_mpath_head->index);
 	if (ret) {
 		put_device(&scsi_mpath_head->dev);
@@ -294,11 +358,12 @@ EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
 int __init scsi_multipath_init(void)
 {
-	return 0;
+	return class_register(&scsi_mpath_device_class);
 }
 
 void __exit scsi_multipath_exit(void)
 {
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
-- 
2.43.5

