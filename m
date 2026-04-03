Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892BA282F1C;
	Fri,  3 Apr 2026 01:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178657; cv=fail; b=a9HDvjWx9imWh1dwJSZQ9COgrS25RG9oIo1LLNUL5oTHoma+vgM226vjsZRNJmacn7qJaFCAaV0ptf/KOSUSq1xCDfLm7Ot4eDHQG6WttoS1WPmWKiCkV9JACsLuslrb6aPRs/DwF1hbWvqzsawrXdPd3/+6YBqVh6OXRaqDSzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178657; c=relaxed/simple;
	bh=hfB5BIPktKqex5Pna5FypuWmBaoUAWBiXy/L83drqlY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YS+Xk96l0f/Zg70bbwgKRRiho3QT0zWWXvkUusVon9gQ6MI7dQX7i2Yxb/xNlvG7uh0cqKHkH4QUmWvsYBNQ28J4O4TXbqwg1+OKGiLbFd7OGeTgTDGF9hSMaNsQL93h8gxNQ7GCsFY3ajdyhTpEYUaY2jjieQAV+5n3oYeKvis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nUU8ugdF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yHCBGRbz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nUU8ugdF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yHCBGRbz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632NmQpm1335209;
	Fri, 3 Apr 2026 01:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FZgGaSuvHSHkSKuZ1I
	YhjywNYmS9TKqSgAI8XjlfmNk=; b=nUU8ugdFhUKtMuvWroE/N90BzQ2BY4102Y
	Ii3/v+dWi1t1sBDdcnytvo85c33m/kEc0wuLNbBcWmSOPP9P+NYyjEeyzbkS8O0z
	SVRjFI+S22GOSUh/3Gm+CVNSwRQL6npt3rx3QANlVt4oUY/Dx/v6JaCedo4lpktv
	yxEihHcrBot9iGRZdBvEADUeMX1eCtz0v8ro/mM6Mu9eSrUSVBTeOLitgrzpm4gU
	aHyCkhcH2vUinOYFg0HrEUmmXEYne5qaxnJeO3bEnVrlk5A9hx+nl5AZTfgPoL/0
	9lbpBWdaE8sRl3VPhzIt0eRieUnwVrS6QtGbXs+CUzFzDw6E36xw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d671b1g1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:10:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63303qEu008834;
	Fri, 3 Apr 2026 01:10:43 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ekpuuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7lBa/ZyBZ96hqELmDROg56teIkqOgsWhJ5gEl7KGa6z+9fwqRejmKTNwIiv7Sr4T/ymfNNGMzBSBgU3mCUIPb5fWu7l5M0e03CRxsg6smkJeT6NjFMnTqcc8df0ESEEncQWbiQQe2R/zzRSVPrdw8X3fgmRoeoN7vICCM5dsuDFtQgB34/zCidZWIVOvJ0UBGhj/oqjI55Me6h+ESC+3iNeAt0wqBs7Z2/xQyg/1MoNK8s9cm2Rpzep/XHNcF2yexjVyH0yeKt/nRPq6bxJZFf8S63DDbwIfR0lU3SWLabEq0swVDJvU60r7QOWeqNfej+m1Z1QfCAvzavMIiR+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZgGaSuvHSHkSKuZ1IYhjywNYmS9TKqSgAI8XjlfmNk=;
 b=tKQIt0XglrPdd+LeSwbC7NK/onzWM5T2rctjzHOR9GhxqxbKMbRRAP3YQBUIaFpjHVuFdBALc2ab/qM+JyiTE7WHmq9SiKyEuMXznisUuG8lHGQLQzttLXB+E1hLe/g0fz9m6bXeQtp6EQap3RQ1Ilwkuqr/tVj5zJXO3x+DXhsoEvuxii+KJQOcbwA2w8KJyAkb40hb+A17ShVWw94LPQ58q2jpRxOnRXgpneuZExaMFRZDr/+YPy+ZYknjlYS5XGdi6RPNXqIxBxoYTY8PK/zuUS8YbYk7s0733lsPq4LDZARXdS+hleLto8Iwmt7LnQY5VrOmlFJcaTs2FeMOcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZgGaSuvHSHkSKuZ1IYhjywNYmS9TKqSgAI8XjlfmNk=;
 b=yHCBGRbzVc61cZ4/kupWZwIYdRWTD2Mwm9e81Xft8LmHaeomFg9OkkA5P6sb0s71d5893VB87n0WBzjQzMuynwv4CAdyYb+Oj1a5MhLmSHUh/+0RU0ue5DPsWk/PNQrdencyCKEvvCbi2MWgd5TqFFM19zqVRvyGsnrYOZ4p+/A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:10:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:10:40 +0000
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: <don.brace@microchip.com>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <kevin.barnett@pmcs.com>,
        <thenzl@redhat.com>, <scott.teel@pmcs.com>, <hare@Suse.de>,
        <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: hpsa: enlarge controller and IRQ name buffers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401120552.78541-1-pengpeng@iscas.ac.cn> (Pengpeng Hou's
	message of "Wed, 1 Apr 2026 20:05:52 +0800")
Organization: Oracle Corporation
Message-ID: <yq1eckw4zng.fsf@ca-mkp.ca.oracle.com>
References: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
	<20260401120552.78541-1-pengpeng@iscas.ac.cn>
Date: Thu, 02 Apr 2026 21:10:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0433.namprd03.prod.outlook.com
 (2603:10b6:610:10e::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c32a732-d715-47c3-d970-08de911dd237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	S6023vM1GMehhZLQQDjs8usmUXSk1A4JfeY6LtcbY/k3LXuTberjf8BA482NV8yXTQbsfL4bsxw+jkD9pQjKIDrOayQ2nT19APRR2ezJaTBHTXDVKhh3nmqYC1QqU/kSr1byAQi/1Kr4LA0qLfgFXG3EA2ho6MOcpsqt2hoZpSx1In7vwTBfka+PmMOaKrrLsOL3YKYfBIt2Gu38zIf1XDFMXGfq8pjXz91zC0rIXnqUPopRQopE3SOzMER5im/lZ4qqCCLf5idG7HxMLjRZqRa06Sc0JTvVByTo2fBdrOzKBnwUqPVGzIQoxccjmPn1h6h7ToCIOICgSePuvptR7ETY3tZ8qm1OzRHt+F4wXPDruEYIO/PFXTe5D8k8s25R4KOFOPtvOT0O5cFr/psGvIliYEUx9H+qvyKlyMmgXR/AX6E577qsCEekscOCA9vKJd2gpF0IUhl6aPd62w2jQu3Us6nmSv9eTORc9K5l5WWhB5m2Xs+qaucuiKMQVNOEcWTX/xLFxGiaQB4e5SvMe/7duxfj4Q3hiKFBNBKpzrJvthYvlRGqiwarF68uqAmULhLC0ONfQBsmwXN4dDrECsnGed3Dvp3K6AuoylYK//AnuAKbc4x+tXPYaRGOjZ5hzdncJQPqqmW/Ig/KMaRXk6x4V3Ca/wv+/xfBWqCuxVn+p6Mmno4DuBqyfkdqxB65cglji0foC4N2dq3c1E6mZeVzQJAY95V9xy/zzESeHSU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qQK7SPJNn/VGIGMYD9nwcjbzqHBV1WAvAXu8r+0M7vuGOlv5ThaQXFVkfwDm?=
 =?us-ascii?Q?cZFX/SYITFhv922oavATrizn3fh44Sgl+KiVn9WQjhKYXreMndFUmUqZYEKJ?=
 =?us-ascii?Q?DxW9jCcfhQr2U2qNQDasCC9iCkJAERH8bXcs4IyrleTIGpeahj3uOx6yFL2B?=
 =?us-ascii?Q?tvJkWYendx25vCdypsKrk+VMfiMQ873JG8/s/os3oa2+xZJmgCi0jWzKHusx?=
 =?us-ascii?Q?Yq8uKFOnf4n442Oi7yeeQ9No5sKh4hc7e5LATuSm+zOpG9naiU7ROZOCFg6U?=
 =?us-ascii?Q?DwUBalZDWdSD2dR41hSjpeJT4ncaj4ngt8w59SUmgnMWWSP3nnJd9/sDKLal?=
 =?us-ascii?Q?eEKwC02YxQgTSktm2+1CABBqFEP7BsFiK2HUwq25Uj3cFRtY6LBRE4MZkPLr?=
 =?us-ascii?Q?3HeckYGI90Z52GzGIU4N3DDl2/TQWr8kf7m9C6y1nJH+Tt2/1BJNRCs/EXgo?=
 =?us-ascii?Q?5Qab9K5s3/SGsSveR3GjXGRY5+SWB3e561VAlWLFIjLyr7HStWCWM8yYOawh?=
 =?us-ascii?Q?BGzJJYPue4bGZ4wXAPjlP9pHkxWspMCmS6oehYakbC1jkIsHScu0F99FPNt1?=
 =?us-ascii?Q?c5UEmCVof2UcQQLjprSuenBfczQl0ZxHSXzscFNKH3Bevx4tFXsQK9ERiNxN?=
 =?us-ascii?Q?LtHbWDdA22Fv6dTPVpamGY7sN28LWDM+OoHFHkqLfaaEFCqv1OivuzW63Q+3?=
 =?us-ascii?Q?66l3brEXLN0A6F3YtrINizQjNuwnY4RM4M8YgCo9RxZZC/ip52ZKywTRZh53?=
 =?us-ascii?Q?jd8WfEOxvn2BkeFTNbITO3l1cEpK4/ajBZlTfMnzUK9p//U1zF0cnUGwwQ1u?=
 =?us-ascii?Q?rBFX+kDZbMI5L2fgiBIgutaGjAFaWZcvQHM7GJsJ0LBOegpSGv8dLY1J5TPa?=
 =?us-ascii?Q?HEVlmqvU9I0jSQZFY76i4eHbHVBwUSXnPnMtWH4ejqA0X7YNV9taTZaMRfPd?=
 =?us-ascii?Q?oD+Th3NTVk3hYJ12w/YlYDVUzKZaRZ1YScfkH5STJdQ7Crcd1EoBa0cH3BxP?=
 =?us-ascii?Q?czQA2d2Y2Jg17fyUj/FyKzpmssMRSVFKZAhIc+WjQDvVPfnB0st/UcazJ35k?=
 =?us-ascii?Q?4aDxN9tzPHXVIavNzpypbdOdeh14l9qMC40t0PYgoWs+ntdPw6VEKIo/bZtL?=
 =?us-ascii?Q?N+fmtamVnsVyBWAm3pIe1DBlSi9ma473QT5GngC5gjmPtvFrmtLhTnfr626a?=
 =?us-ascii?Q?+Q1xzePECNZJ2CBPnGQj53Ss2MH/MReyutjqHk4LlbEs7U18l3NgCU956SgP?=
 =?us-ascii?Q?KShGtVHeCiE1EmusyikqZ2k64tV5iLmIYBUHD21CZD/zWFsXbYgSHq/b2m1F?=
 =?us-ascii?Q?LuHPjyvyumJlqjb1JCupHO7nPRVi6QVB4biKpw18u1l2mB3AraFCW7XS6PZ2?=
 =?us-ascii?Q?r0x7NJitGL6QqsR1CWoNuVtliMCPH8v30MywOfp30J+5QIZ+vuzLlDVD+mzA?=
 =?us-ascii?Q?LMcRmtoz7yRJ7MJG+Ywv1/FBcGYAF4TZu+cU1GFQHtNJLeJAiZYtgKGwlgzB?=
 =?us-ascii?Q?NXogr0wKkkStihCIic62KMOs22xnhC48IMD6/0MTERuM0OqAKKzAKhxtQSkf?=
 =?us-ascii?Q?Ha71cYrW3UHU824TTTS6l+hHKLi+3K1f8Mlovn/75T8hqN6luuv8B1XCM6ML?=
 =?us-ascii?Q?3m9/Zl6FesPFder9jTpX7kOEQabRc2Hay0dQk43KXbAWVZVzIT3hfUJdJb2T?=
 =?us-ascii?Q?LcFwgMqWiJrL7HzmHtTdLl55ZYJpCYZ1tC0Emq6zEolWYnXqtZ9enmWjEV1C?=
 =?us-ascii?Q?7P+xMGDCdGUerYZg0hU9x+dSIxEFLP8=3D?=
X-Exchange-RoutingPolicyChecked:
	oeF/bCv3AVb2cnCHUOeiTJq8aZqEtB6yxOUjYgH5hkN8thXqIX1cqtAjZnnZCIA0XiWwAfIOM+D0fOo52iL4d5xqtZYs950VfSOH2+MP/or+nToNR/EhXZs5yvp9iCfO4MM6WSJ9w7q7iibxjVqgltisXH5F4ZQVFjPgdke/w3rGLqlDynHDQRGl/bKHYLZEMj74JFo/bfK2nzusQ6yAuRLRbKWDABTWOdG+N6fYv27t89q+LyWWGH8No52HEGs4A3VNe49zUqY5b0181aEwUJP2TCdGzHGcVUsJDW7EAFv+oVpkTUh/08qO+jYGWcCAYBBLIeI9qg2ueY3UtbGfLQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C76CNWSlx/yxwbPHf1x3F+rHxSVS09cgagIJGkwpFWyWPp05GY1oigjxfaSzN6IF1VRBxpn78gbumNN4UFG9O2n+nCUQUJCNlNBXwpc7odKsIwGtSCEvmV7Yug1tfGWUlGUikiGOTwOUwItOfCNYjPyRYiXt04UP9lHK9BW2Kk3vxyiyYxE3Fero38ljlUu1iKa2DtE9mCz/BsoAM2xt9Ooc2cWIq+ghek86vyis1xwfe1XluLm0DGHI0UPZnifNEJnZiB5pazUcP6vzADb8EpzCtAVsG+XFL4R0vdeRmlrn3PQMxhs9lCGRquBMRVkmKMNfPyuUXS4m888fRT54/F2xU1HkAQROS0EXVkjxXw5RDCfaEKO9jMBXReHSsdKmMLN1PblTulIINk+CR1uEox8+mFne0IFdqzeqZLvMFywBYu0M0GqWr24+KcxXDBXgbXygDG9VUC1ABWI7ZU6xy0gygoDu2SnmidI3TxNXIt7PA3A0uwlBydGxB5MOOvjimHeAutEN/1LHAleDZQ+yMpqW/u3dLjX3DBRxaspLuEQu3gwStvndvdrCzxZ0Ll8ZCPKar1kdldubJLnSrOlf2NKPlfG44FhZ6lc6zSXVtL0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c32a732-d715-47c3-d970-08de911dd237
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:10:40.1757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBDv6kwbdFoGRBB3YCSBPYFY2vb5kCkHkwHhfsHklx+eVZgEIKsiXaI7Z8arRdf5O80x07+eZ2hM09cYkHUJVpRWt4R4b88VMia7TVBiIBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=627 mlxscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030008
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAwOCBTYWx0ZWRfX1ApRBYiXj83O
 GMDl3BGT7zYoPYC7oaAcORwe/EPTyCLBzJg1Wd4QgNy1c8CAglSscISyIcr5TRo/5xdAkUaSC83
 5dAlps7W+eGq1PDYGLWkZ93ZjSzJlinkkKTki+917ZsKrtsqyp8+7FY0F2HZN4Wzo8PiOHZ+DwC
 FCh73EHVL9V1CRpcn0VA7cwQfuWie9JVeHFtW0/oawx4Bwnj4ReO1UY/byPUOWPHn/A68EgcnWs
 t+TYuJBGlcdfGC8Qjt2/7M5ndqVtgKQWMQWlarcBDSzI/QlQnEMKYCRXWl433K83nHFo6hs8S4F
 4Xs6ELQtGeOTKDWdIS9Ty5xm+c8J9YT4QtyLD/TTPgW/9Rnoiclpsz89ztokzaqEAABe/Yck+bU
 8H/JgOyCSIWPesy42tvY92Z0+GOojqn1+loxsREoAfFWNi8CII/ICls4O64//8A7wLAJ4quh6he
 J1CCjV6BaaufC4ct8ctX+JoKOrYO1K6BtPVozDmM=
X-Authority-Analysis: v=2.4 cv=PJkCOPqC c=1 sm=1 tr=0 ts=69cf1394 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=w_mH94CplMCoyiTAYA8A:9 cc=ntf awl=host:12291
X-Proofpoint-GUID: EfP3ncgFN1xAx45G6uBJK5ybXl5fhFKt
X-Proofpoint-ORIG-GUID: EfP3ncgFN1xAx45G6uBJK5ybXl5fhFKt


Pengpeng,

> hpsa formats the controller name into h->devname[8] and derives
> interrupt names from it in h->intrname[][16]. Once host_no reaches
> four digits, "hpsa%d" no longer fits in devname, and the derived IRQ
> names can then overrun the interrupt-name buffers as well.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
