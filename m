Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AB0328610;
	Tue, 16 Jun 2026 01:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781572174; cv=fail; b=WowMI3UqAXR8BXFNKUFcSBZnocsmB1DH2KWPVPsHIp9J5Ds/nM8EYX8FbJwEJNlgqdODuJ5SctiYW4dLz0m7pi11ll/QhhJTUAGkqmr+4gd7QIwsEQp/rD+9dkGqWunUQGi1H0DUUt5kh2sj31E8fizzKeb+uH5yR/CDdd8L0tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781572174; c=relaxed/simple;
	bh=XADVU9AuIOQLGQ7leoD/hMWLchRRaiip1tI42GDAH8Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aCq8+dykJ/NFsVZg53lcREom9jC7oBL6f9zzn6FXYWeugPNwNtT2/uxhBwUEIB8YEzS7oxi66td/bzKtvaokZZsb5L2rlf+eOZ8K9UBqYi2opbB4+SbGYHkQ2zz3X2dI8qP9GBsX3CWreRh7y3a8h2JRkF+POZZrijoCAOGYfTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bYE0faod; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rudQgKmO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bYE0faod";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rudQgKmO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FLXmRC1304558;
	Tue, 16 Jun 2026 01:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bG+a5Z4/+btmWc3IA/
	Tbp26busUAWdxpkJ9aVx8tAe0=; b=bYE0faodiTtiJJ22sxFYqJhPnRY78Keac5
	9vybbfi3RtvbdNyFhX/u8ROF8zg6iKKJxEs5r5prK8yrgxz22QGFpkoDNaQQzN4o
	8SzBU3l7hC6Oex+uMwB6jISOQJGtq6utGatPEzovz42xKE8DWJRNs7uQLg3+YKdm
	VJoLk4oOUB7FB+hvyedTc6Bri4yB+jwK9L0wglxK1glhWfsUkbr8WN8G1RpXHm1V
	Y6kzZeBB/33nRXBC6aVU6Owo56joHq7KrSOy+j52KjKRIv1vyv3hJ377zvWu2w71
	WnTjEhfmBUf1qOjn6CjG/U+p1vJWOwO7749TQBmlcXBU1/MybfXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1hxkgm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 01:09:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G18e4f004955;
	Tue, 16 Jun 2026 01:09:26 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010009.outbound.protection.outlook.com [52.101.85.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpn042-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 01:09:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+vaBauHpUL83MJhVD2TEmvOFlZj8+y6I7/l2DcaF1PJ8WsBTEXOtLmk7EhDPR2Y9B3xpU+ROGp96DfE5zv4WJtsqVHhmtMHds2Z8dh/bgIxss5xR813oZI9X/LIlCRNK8VOCCRQAUCVYM8YV64oeLOzYzlg+N7NoTyvEop/7Ap2y53SVpdJzm1k5rba6gBTnoj3IvA7j2TLTZK3mtmkWbRO+JvuWlmbKzKJbMsaPKSyvBlqDIw7toqQS/vC3YJAC8nM7icADQ478pXy/vUYZDi+2KETMPJE3jp1+h+dxb+dTF1MCoGJeJatTJPfuAdimNTLrcr4OVxJwMMhRQzMfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG+a5Z4/+btmWc3IA/Tbp26busUAWdxpkJ9aVx8tAe0=;
 b=K20AXJu71qd3BYG0SEBc1LdVEiHnV7t07HZ9H7BVsQKexvg660co3GPJPyL1hcyk/KvW6zS6pttBEZRriuLAm/J4dpjc3gEQwNjsAQqqXYMG0bMsfOHBozXab1T1e1k5OQICPyWLPWrWZKYlIGeKB95QPMFnZmlyIHdtnVbInRpJiwA5NH9puDytn7zxXdmsXLrvgPmGv5IoaXniG5CI63jNJuSpRboF5h6n9Up3KNmm+xyfE30No2ibUE0MlJNU97MHjUOjVMpVG6gvNcQW2yZ552HDqBHe48soT8OOY/VNKU6cAi6qilIf9XfRKyrcReCZXCBwYjkeP9GZnZrKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG+a5Z4/+btmWc3IA/Tbp26busUAWdxpkJ9aVx8tAe0=;
 b=rudQgKmOngAdhusKEar206XwgYhd2TarM0THgzglEAg1rWFXKkJsQMU00yK48HBCpR2cnGGhUcmjHOVsuaLFPptIUeaQTMctnH7ZrsujU3Hp6m07ARxaFGfe+Cte9jOd86YXHAZJVFioSrx6XS1MQqXmhpvcPsnowVbZJOZGxlU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7497.namprd10.prod.outlook.com (2603:10b6:610:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 01:09:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 01:09:22 +0000
To: Phil Pemberton <philpem@philpem.me.uk>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <cassel@kernel.org>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 4/6] scsi: add BLIST_NO_LUN_1F blacklist flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260608213443.2296614-5-philpem@philpem.me.uk> (Phil
	Pemberton's message of "Mon, 8 Jun 2026 22:34:41 +0100")
Organization: Oracle
Message-ID: <yq1cxxrwatv.fsf@ca-mkp.ca.oracle.com>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
	<20260608213443.2296614-5-philpem@philpem.me.uk>
Date: Mon, 15 Jun 2026 21:09:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0198.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcdd2d5-c627-43ba-d62d-08decb43e69f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HZAB7Y8ffk8TdE4OMGB06GpZqbD1Eq1lWo8sIA4LEiqMpnPlGQqEK92pNEDnh6+N7c2n5quhJnvWVv3rv5BfltdCUt7OLTGFxBxRsRmAwEp3N/eSxJ93cEQJV3GvcbIBmmS3I6Dz1FkJW6aKe4gtVqwCqpX9ztbOpA109UYh6o8KmB8TMAxUvx+tl6pJ2Hobqt19ecagKjQTmEuvc74/eQXreGmxUTZxPrERh4FDEZRSIAyfG0UwEKUmj5GkgCUeOoC/mTBYj2Eh9ocv2az83T0OjBxDj1nlju7QdQJpqBOv8fNxaANuvMnHkxlONVtSPuTYmNwt+kNRKEwOenUk5La0k2y8ypT7Ezb27pVfWOIEIhSekCE9415fVoARYiM1dfOvHtMgOEOzQmfU18SNWyAdmtU/RNQOb2BOyHVVYYqxet6AHlZoAg0rsclXtidoGXsnPP8H4KA0wdS8IA2QLkkKw7O5Ial7snVXZna57GrNjXHF6mV+PQwPa4HxDw1yBbDnB3574I0kpVKhHzkX7wnvftUVfYj6fUAnP/yV0HTs1pZs63/dmBlMWlYHAhGNX5PBWCHnoMxxINg8xjmBoL6jyQjXfkSeJM0C0C97lIiX/gtSy8LDmtDtRKmoxYVk0A5WEsC3UZwnboLsYm5Bf8VDvKa896CSuftgpSpIbejdk6pkh4KXHdzROMqKGXL8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OH2IBswXuE3ZuA697oaxQLhRm4Wmd1mEaDFlEqd75UTpxnxAop8mgug2gFq/?=
 =?us-ascii?Q?VBZr1RP8PmzimTC6xOFR0vibvNekTdBFS5rRFRPeagiiIBld/Gd5AvF4tx/B?=
 =?us-ascii?Q?frqA/KB0RhtGN7tR3XRmH9chS42zvwIyfijrU5IFk7c9OK5jAtzStuzowZ9M?=
 =?us-ascii?Q?obcD6Npfb/cf8XaxpJYqEDg2DJ2zHnMrstH0HyOD8fLFBZA0+r9TZx+66mK4?=
 =?us-ascii?Q?4jqhCB4C1mTS8QVl87F5qKvygVP9BHJN22HJ67YGKzMkW+Y0T0kzFJD3o9kt?=
 =?us-ascii?Q?9MljRzFS7WhXx1IstPfwZjWMjH1sdAsM+lHrfZW7/08SRO1w7jMIc3qbxCeA?=
 =?us-ascii?Q?9mOLW7n177rwgX1KQwBaghVk4baT7ZfQSoppEvJSARfTwe82+eWz2lPkZ34m?=
 =?us-ascii?Q?/4AdSWlw38WIiC68azZ/hNzCCyipLS0R+PrEzC0rqDOp6VKgIwYwnn1+HDpR?=
 =?us-ascii?Q?ZU/iXPlTxsyGfxkUoAMcmzNIDOUP0xlt6yAdKbpV5MuNgkAGLM0TJ53cnsN+?=
 =?us-ascii?Q?JCfv40VCtPFFR+6m3jgurmlknKgLKgBQyELDSe+3wRUaZX2Fx8JII36Gq4Rd?=
 =?us-ascii?Q?1GOto8+Jf0r3AdQRs8o6Xxyb4dnfBcd8sgR/klGAPXTEbgiQgDKXgUA+g+Cm?=
 =?us-ascii?Q?3vIXTYPUGvJ0VnvkTX8nRxJRO1ec5vgNnQQOXXttgZ5oLCz/IgdUHCEjlvQX?=
 =?us-ascii?Q?0RUXsQPEZb3obBv7pEWkWcCk6p3QIItIlBny0NXc++gxfwpUvNrdCwu4qAw+?=
 =?us-ascii?Q?EVF5oB6LBNqsOMMCVo++plZYh0eMRrOcHYU+mMOovi6zUiL8ZqtgrL28nIvs?=
 =?us-ascii?Q?oSKAdhRaEi7+RBjzaBIKySijEUdyFrdtb1vO1MOIi9WkDnUp/VALdnxKgUtZ?=
 =?us-ascii?Q?WoUIrMM51H5C7YrdQTLbJjv0H+712JrfS8PFxte1ZKAlF19Otwe7mKiCz425?=
 =?us-ascii?Q?g77YPpHxVydM0Nr0LwJfZQMgAinyGCb9zaunOHkemKWRfR/8uvyqRSj7Su9s?=
 =?us-ascii?Q?pyw94xMR0eFRE1eb1QqWJvf83NuctRT3AvZmiQoKBfHHSn0KYpxUaZc0VVlo?=
 =?us-ascii?Q?khxw5QSAIhkNzo9ibgxKNivYGRiSJkwCV8/5325/X0zlgi7g3DFK2gOCGt/A?=
 =?us-ascii?Q?c+kA6w0ZnKIxWop/iHuw6NXOYegwJuBTgovskPh+x0wbMvDKZNk3wVgoMgrg?=
 =?us-ascii?Q?QVlWZBU3vmJrLPG9+Fc+vZae8hb4lGJt0MTQoUlj0q6ffy1ViEM3pCgCY5qq?=
 =?us-ascii?Q?mtSoBFdNdN46o8XXjGbDOZZtocihAzm9ZeCEOr45beO+p+LjKbSfu29d7ynO?=
 =?us-ascii?Q?eSTxnvaiZ3wguZHpbPwMBO18vNzh7NeBA0OYX2WywUFmik24rorZsxAxntqJ?=
 =?us-ascii?Q?k0AGO31x/tup2+jDPtSVUlgwT+FiEf5ScH0A1I226WCGiJavtzV+QL3LVvqp?=
 =?us-ascii?Q?AxhvFqfvApkwuKtYZyI5Dnn/YsRuYiwKYjsqN+/dbVCn1kUmfBua8X48QkK3?=
 =?us-ascii?Q?4F8Wzo9ZYEMQFPW4mvyYpirvAmWfJfluf5E7E6deu9lYdJ4nX5HYYxcesiKu?=
 =?us-ascii?Q?ESlTs6H0JV0ioPhpZ/TqqefRp0bJzwDfw9uascLHfAK63JwWDvfjhSYN6J5m?=
 =?us-ascii?Q?aUKB03R7IiPhezCbfVPX3pI67nGhA0UHj9M04yyAKz1vPSQxltnlTqxAiNCQ?=
 =?us-ascii?Q?F2o0LGutCbdM6Q+gGTu9B20PPdM/JFpOpi1Oxd2dofQQlrC0E+ljqAuMFnZk?=
 =?us-ascii?Q?ZPM2uOVMVOc2Sf/ueT+QMdtwGMt4mNg=3D?=
X-Exchange-RoutingPolicyChecked:
	SIqp/26IEmJ7a+xyS3hYqy6yDvCSCoKoBWtGWoNcN/+NKqadSE7K8wnA5mAIpjngCWArupmTCASI4zw3nfPsE4bgSwyusMF4Xrsgj/fSOt5PIiob2il0XXShOnI7AVbz4LgJNaY6CL5it/MJr6u51HQdpT2C5Qv6T+CLtSOC+QRNvU0pAXU/aLXAuMlYd8TPDzU5CRQffwx/HK041H6BUbBpMSO9fPCaGb9/zniDjJQHUyn+OwDkLcyWbFpMQoj0XgcCMuRHLDbxywiCQjyNTxFrzWMtY/uZXS4wzz/x0qqCwM8pHlqKmynZc3Li94MIeuWIitowf/5VwoPJktwPvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2KXoodKFEVtbBWCRROwhaSpX9uggJRVquAQQKuepLQOq5MCI4fypngMpWhOf8JVxC+QWkkpMMid68YMtBn4RLRl3kZbytC+ug62v53MksX4cddd53pPoKvW/X1VhfgNoItDqiAZOoeFiLjceMD8tPQ5dsMtNHYGO19vkrcbryvH4ly7VGA27/r8TVr47t64v2TxVJk7PLThG4oDyGScgmXC4hMxRGmcmPzDp8pMOS6H850cGqe0+4FA2j3E1Fw3utVkXb2QzH+bIo4eSZh4WF8enbyPOylkaloOE3twawSXYvkK+FzLTvFl8xBd8RRAbBURMxIr7+7q23mEIhhknV+A3IUGwnzEpSALmI8b1XN4uNCcgemk84DWWvlEXTeLWXQriSIKIUx1uZS7VU+ImKNp/XbrMe5yhuqoNA+GWSP3b/mkpr3kz2Anl0IekJ8m+undxWrdiJ676+mssR0NIM7qCzi9Da35NeoXna/o9Rey26auCsEOp58xYLLIihRN+oMy0gfOBwxzaSpjYgzcDWJKzXvGKL2rHYjnSUhgE0Rkjto6tW1LJm/SEGvyJiPCBzLQeoejRI7XLrCCD43NG1b5BMTQrGEjNgkMNycDfVK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcdd2d5-c627-43ba-d62d-08decb43e69f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 01:09:22.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uHEFgiiiNZCiCWHEzGEQXaQDtWDwgiCe+RjTFFH35XhhcjFggOqkoPyPibpkhTfvNTdXwB0IxfKu+YVrijQmYq+Y5aVOI/efT9+iPF9UPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=964 adultscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160008
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAwOCBTYWx0ZWRfXw//LOGG4J5m4
 zgxTtFewhsCwHF31mXdyG5xG4VxUDA0OWOG2b0nl17kvZZo5q6IeKP1ZCIj1OPNfPKos85RbCdX
 QrygqTszbvokFLlZkrrWFjiR4wZ/P5yPXy4ittvLnfut/mndmiap
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAwOCBTYWx0ZWRfX29gK5rUJEmIw
 lfThSpiU2Cfukl8OdF3YuBz9ZF3HLAE5ZfLW6DPfavSGtoAmzKqum4NCd/V4S8Ep/wtt14d6KcJ
 N79k4p0zaIETqiq+0YCq443+XabwIdLxBEjLAiHtwBVDdFO7s500vl7ghIO0c5ZKuk4/e1+O6dm
 xKbd5mRKY9lmrFGW2LNS6VIRIu1sndzoL+ROiNdG7MLPun+ixb40NTm5qH9B5uEW+g0XunRAFzB
 kPrAw9l/NxuX70g+YJuWzk4S4rPTV6MKACb5qcM/tFDBBQ+m7Uaq5lZqGoRNFi4Xsz2KKyHBPqK
 0Uh97r6SkpaVfedq8snQA9mcUQqlpYo+JQfQ2Y0ICNYmWN50bC4PHdY0vmpgDnKkvMaS2SBT2ru
 drzFbMtKpY5JKW7/Wdob/qPF0qBBu370ZMyu91IzOICY2ZEPkVkyCuz3HjS5gH3BOvUtD4MzdCe
 l4vfwXq/kmFqqs9FMYIDAQmJ8He2GPi7e56PnmWU=
X-Authority-Analysis: v=2.4 cv=I6pVgtgg c=1 sm=1 tr=0 ts=6a30a247 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=xMbP0jYjk-th1ZVw4kkA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: R3dgeJ_aDBdsNmrPr5IDQTSQBON2FJvG
X-Proofpoint-ORIG-GUID: R3dgeJ_aDBdsNmrPr5IDQTSQBON2FJvG


Phil,

> Some multi-LUN devices respond to INQUIRY on unpopulated LUNs with
> PQ=0 / PDT=0x1f instead of the standard PQ=3.  The SCSI scan layer
> normally adds such devices (PQ=0 means "connected"), producing
> spurious "No Device" entries.
>
> The scsi_target field pdt_1f_for_no_lun already exists to suppress
> this, but was previously only set by the USB UFI driver.
>
> Add BLIST_NO_LUN_1F so the flag can be set per-device from
> scsi_devinfo, and wire it up in scsi_add_lun() to set
> starget->pdt_1f_for_no_lun from the blacklist flags.  This runs
> during LUN 0 processing, before the sequential LUN scan probes
> higher LUNs.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
