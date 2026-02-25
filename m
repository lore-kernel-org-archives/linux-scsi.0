Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4393D6666;
	Wed, 25 Feb 2026 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033847; cv=fail; b=PnXa9tj4sTQ6csJSCEO70FuFXLe6RT2Ft+k2g1s/WOaAW6uOXnIPbQ4cEEmYkHdX4TijpRGZDyKT2kXVTEgH6Qp+SvE54mAGfY0kHoW8YtpAKGjdJ7bj9ynuqKIMKTsU7REPRn76l4rsBdvD0yQyzn0N2kPW57q26dEuxK5KVQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033847; c=relaxed/simple;
	bh=0o6CjzA9v0pvDm6Ybs/L07wmzCUf25EOyPjT0bq9eqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lkMfjmsHksMEp0un5dEq4r32VvsJSM6j5db+UMPNlrBE+DxuH4/2IswZqYhijehF8tKIibhfLU3W4t+VRKfHg+X+rSyEnMrr25gHz4v4ucafLk8G0gGyETXVcs+De8HzV0VGoHTp6BgPYL6CY8gHxKIlEYzkRQXRj4dz5shoD5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=elZzTjdd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YW+kuPLE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="elZzTjdd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YW+kuPLE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9hrEt1959667;
	Wed, 25 Feb 2026 15:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Exm79OwzNg/Q00hfsiso2MbSFOBipBU0w+UR3nXNq+U=; b=
	elZzTjddgebNT0ptXfUF7EUedkn9mvMWSV7v/8JE0gY7N0fe9Q8PuqHaXoq1mObD
	ZM2W6owiAmi6QT6hO1pRPVsJ3ZbKlfAZmAUyPBMlc8fubliGtE9g2L1gXm9ueo/Y
	MlMDvtpOK7QnJiW0p3V+dlJzCOFFAjZgKAbfYae2IQj+5BMScSDPeBbjLZt5Ng8Y
	zGjfzFs9MXvoSl5W1WeXb/OwmRnPwHWwCLMnN467ngnob69480pEi2PwTRH0h4Hj
	bzDg2SbcfQ7gu4TnNL07050Ct7PRuT2onDB5HZuva0QKP8ZzJYibKAtjp80u5koN
	l3jy1vV1qBUQG4UBCkJubw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbegh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE7QHT006382;
	Wed, 25 Feb 2026 15:37:09 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9h7-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NH1c1m4K95HIoGv/ab1qdwwqnQocyCX0qRCQDjn9QwlQgghaEQRrhiipwYf+IqkZllMwQmtU2OZnYC3neYWnMXDXEXRE+9u5DLLPDHwBaUrOxGhOdDxxujv0aBHq0dXg7WuxTXjCzm0POI/pBOlgokWzgFZlfStf565kreSAJZgxAETprDLCgxHVukZTTaKrn1A2ipArkqseF7n/SKk8kiMt8dv8UvSXfrcGgjuO2JQozCTqziYft5LWzBhihPKC7HTZzB0jA6+rAgM5ox+qtQxaLzQ5MD4u0tQwTiD3vSuA2ubzFQua+jrs0KpW25e+YNgSCAoMcOaH3wZigIVVlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Exm79OwzNg/Q00hfsiso2MbSFOBipBU0w+UR3nXNq+U=;
 b=lRPTYoZe9kYgiCRO7lL6iuLQ22xf68Qg0BkRiv25vITcsAIUbjlY9splqwtMbFbITfNuFIJsqmxKPUFl8diTec3EBHWaL35RfzRVd+at/cVcJ+bIOqLxM6AlB7i9br5fA1fVuU8E3oruQfEhurG0xc1ygDlKAo891gTOfSMBSTuaSqTuC0V24bSb50O/hKtjxGhCrFwM+B22RmhlR98OU9mZe4lySvESpM9550lYt/o7bNBQlK18BFQq0Uz9rljO3p7ZQX4D9Ua4W6g0VlmobHSs9r1Yx7whxave9KpkOKszkjJARV0YT9rh24WHpT4SN3TijDJ0OHeVX2sNgerymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Exm79OwzNg/Q00hfsiso2MbSFOBipBU0w+UR3nXNq+U=;
 b=YW+kuPLEXXizBcZ0ZI5qeDxXE+YVWWhPM7zAc3F0ExqSF3pcCaEfL8C4Pb9DMAHlq/2gO7qxCaUTRWtY74IofQpsgMvFR8JMOyTdYQV7gSIjO+s/u+S0dfTrXoXSJ1R/vYYCzXaY8lkAgRx2kezYK6HkeMz3sZDPsiFAhbCdwhc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 07/24] scsi-multipath: clone each bio
Date: Wed, 25 Feb 2026 15:36:10 +0000
Message-ID: <20260225153627.1032500-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a7a2dce-d369-4084-b21c-08de7483b57b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	WCimTH8LkjXPx1+2s8trR3pSTkI+qRy/TXLWZzyoQoUugwi+GQ4ZuxpS9UwF/w/dnVgZ8YrtHIDEdIPLAMuJkReKjOxOTrJ2W1jT7gu4kptaOsnAED/L3MlN7E6eAjoq+Rnd/OhWRk36NxyAMOreHt68YWCqFeGRyCqwZ3DOg5sZNHuHf0LeQGYXjed/geyQO31Qp4oWLJ3B1vFi9lrLLKlus3p2e2BiGCjcfDbJEFSXXW4H5VprkRIBBJNsevqES95kK8VhQrniwHto6ZNPbIygrKNgqrJPpdZ71ByJ9YXrE0BTwbSJF7SAkEUjGIoy+FIhvsJ1eF8zT6QR50AToYamOqR3Q/dZK5FVdIPqtWerT/eDSFXUUvWBaTUGv0z2q8YGxsApFGd3cV05NkgsHjv5geCYSzs60/dHBgTijFidL8dRg0jlHnX7+PKyUBrUXjP9B8ksdTDRbFJgPjoNRJME2ZMkQs2uM8GhoV0U0tR8QhpAeIFWNiVRJ6+kXK8uE7D1ZH9pLbo2gjXfawxx6rflx3EUz0d7/B1MM+UUIGn3AvieuDjwnzsQjG13FcOeid3cp2Q2arpd8xEcgIIF9nWjpqi+6iIgkRBgr4OBNupTKf2qO8X29ROSxqdO447VV68pLwhDsomhcZVEaF2pFUCHywZJv2RLIcMlB7MPu/x78vPGuz1kJu/IeAYVLPXjhXN12cHZjrq6VL4QLbmiTDZqJSMr6PCYGEOtC7Tfwto=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TQQITOP11B/lFYawx+fhz2V1gkj8W+ZYvlkQSASX2uKAox6h61swKP1H83bQ?=
 =?us-ascii?Q?CvEQoXE+vcOSjFKXuVqKaJ8XRgthIge1SHjsZPKAT7KpfzTw/0dZkUxpjkUN?=
 =?us-ascii?Q?Mgou0Pd4JjrE9USp7v5hSqsZdOQR18AoCVC6e1vJtHNxia6W0E6Ob62w8ak3?=
 =?us-ascii?Q?OokWAT10k5+UC8DWtJnqo9n/shD/8yNnwzcDaG1qq/L1DJ4mu/OyqjivPfS4?=
 =?us-ascii?Q?TImWNfZ/sIjCMhflhhMN3wwN9y5DBVgrU3IR+sB+927E6k9X0S0/SIjNffQJ?=
 =?us-ascii?Q?hbsigzSx/S2Whauztwk/1o9e3EEx8PTCSnctTr3/ddWDiAfSdsyJEoR6RB94?=
 =?us-ascii?Q?ghukzceHDk3dqfpIw5kmI/onuntjUi9peMvtXtPR7seMuIbPmGTQbdLci/E8?=
 =?us-ascii?Q?64gJgoN/S+eKtWuKHr445I5TpPmpmjU4GBOXing3sbDGuNKR9tSkNB0R79Bh?=
 =?us-ascii?Q?Ovk7YmtSIH1XjIIuxHglk10dJurQPHv1Z3N+D1Ejp21htuE9CsFrGDp2m0N/?=
 =?us-ascii?Q?UQchlZFUjghQnJujWBhm4UV2HT0AYAIQCZ3OJaM48p2hkvKCHogJ9bM+do/t?=
 =?us-ascii?Q?cE5BPKoD7FyT5xtzzIgbdhgowCSs2eKtp05h5yGDIb7OdsS5wQtR+boyNUvP?=
 =?us-ascii?Q?Fcun6SyHyJF6Hy30KII9mOy47AQX+1kN01o9GSSIjrFpUwrymwnCkYUvs9jY?=
 =?us-ascii?Q?tjqufj95plHiOSOEdCnnUaQ/qZ86hqZwy6rH6fvG8jg8xmoJX8Xk4phU6elH?=
 =?us-ascii?Q?kgZUAEFjqrboy6iC1idD5gPFmRgk0Z6U/r94/72p5GFWkGt4B5HsVHYpH/ta?=
 =?us-ascii?Q?CJ+n1ijnwyEt5lxCT96EYiU8Qu+euMtY9y1lQj8F0qq/dTIMwJRUi1Kn7N1E?=
 =?us-ascii?Q?CS741NbIOtK0NnspyrMF1pjxCrly8fd5rQIgG3YwOLti8jyv6hniOAyLfk07?=
 =?us-ascii?Q?YUf7QNWwH5hNTL/57PTILmBmpdOy8Cb7qSNF89DbB7axth03IXdLNDYj0xnD?=
 =?us-ascii?Q?98Hzg8kEmNRZhTim+9CV1U3GiEH6qXl9vPwbXphqxJZRldw0RUymG86qH4N4?=
 =?us-ascii?Q?7sy7iIIiZqJ1Dz5YmRan1jh+Tq3wGEeHxQeUy2vrtlPc1NFx7NiUjYpjJ9M4?=
 =?us-ascii?Q?WjA+X4eQnYQuqwCJuXwZruKfwthh0FXt18ii4+qgP6qUGzRZyVX7TDj5f1pT?=
 =?us-ascii?Q?oA7D0UXuhp4ftGXdRtC48HA/GUwDkVwGen1GDdZp/kknThNlemkpXmZx4+yO?=
 =?us-ascii?Q?nx060pLPt2Gp0+WFFp1eJJpUz510pttrtt+6yBLOgrPOdE2o4Eu8hEq641OF?=
 =?us-ascii?Q?RDdKXB+VwrEEwIUYRu7zL5VdbUn5WxniuPlD7Zj/yfAw68gRpQclW+fTVWOi?=
 =?us-ascii?Q?4O6g78EFZRM27lWMMSIFDqa1TFJ78naho5YlionC8Qb2Aou9OyyULtowmy7K?=
 =?us-ascii?Q?rU6KemNdbEaxBAqbyaqxZh6shB+Ykzb3BnrzUguayZW0qdOmsGt5EsdEnXyL?=
 =?us-ascii?Q?s7Ps3xX4pVWAw29x1sbZ25QrvB4bavfGrHZoFRaWvy0noZrpewPfX9PkwGFM?=
 =?us-ascii?Q?kDBAmuWmfoA3Hwon+2lFlu7DQkyq/bHPvNKEEtumRjEPvxBKJSUPF8Yxnr+j?=
 =?us-ascii?Q?ovHUv0r4LJ5mSPlPqTKEk4pZYtjWGxXOQOgzkTheaNKdy4A3+mUiAox4aSOw?=
 =?us-ascii?Q?lyYyaMjGYaImM9SnfzfkgKMsqXP4TcB50LSwwW1GFu/3w0dcW113fpGp9LPo?=
 =?us-ascii?Q?LUhGuYVBEVVN2JfePP5lbZpnNj2YXgc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f741eyjPxf28qPEZ+YQ0zLQyxMLTqMklxmThxWLvb7T+a053IvEn6t1EJvvu01gQ/9d4b4gUHMPOsyZPhrO5pcdDMl5+FU9pqSpyokzRvw4s0/lSPZLbujSuDcWv5u+A9pMKZTDP2MgXWRKIgnnPpc/tUwiUlyWOa5UbzafD5Up/Z6ZrFjv0DPXdFso9xz4ktgTdu8GFvHwZP+N2OolTpQ3FBOZArgrWAbyBmvJTu/XD9cF5j6vsAkxAl1i89rAtX/tkMdElYBBhIBgLfWntaQ3MfTqIU/1HiySJ2w7YIAYJxEPRJu+yp6MbC9Ri11yQhubuYcvcB0ZuB+IvvLfQlc7zfcgIfVE9HOza4sdZoyCOLcfRrzzRxJ0y9ZYJYtGA8BnpZdmDGu8LrnyirRO9LsXg+0eBb80+7RKZGaCoicPG4dE32Aq4Z6n2DNjXtHEcUTDii1AOuBvdPWwOXN1sI25qnX6Aol32Gvwk9SUGcjdjQsJjTbXLXzYezlRH+NyAISskflElVBVy11+fBrWKegp/EsaHgXHAHCKE3xrnnl46b5RGAe46MyA4/fwdileYOf71qoKoqjT1OHANm8txd6K7K7KhhpLIuWCVez0x8XI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7a2dce-d369-4084-b21c-08de7483b57b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:56.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+Duc9oNcJ3Yntk4YY3hAquTzOqbu+2wMfZUgcrWtaZyQgdlwNsN8B7UmYzVqzt5b6N0hDqOh/WBTEySF3aL9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXzEGKEObB+jBa
 NNIK+gIVCxzi0KDikh3Wz0QfmVsDhQrY0fiTn9oW7ILDyeK5PBNRi0KYx1Q4GdS0XRVvMiToLAm
 RIqT1pA6mMmVV3ZsdUM028Edcp4lXE3BtnTwF9sQd4gyBwz6gabClvG8gjAB1ELRfwHKYuO4iaP
 z5I0yGAy6NB+B1cIqtcYSEQev9lRi262qN47rtoDNy5/cAOI/Ry1qJqBy61bbkI/QNgqokLApE9
 BGpPROg6ojgu3nO+TOSyKzt5bSpI+INrp02YGy+x0IA9OXAXDGVcvkPkFgsvQuMfMj1iZYB8zgb
 yybRGFTC/gcGE4S5fjoOojYKK9OXpmnqT5BRYCe5tgzZqoUqaJvoouKstaTrDhVXnwP2PfDbkG5
 QFYAM95iQ5DvWTNxxm7pDThsqn/VCAT6UQ+rHjVOskD6dVgoqN3maVt13uoR8RvhN3hT4y4jRlp
 7MLOyCiNZokp7KVI7Qw==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f1726 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=ZdkLGmXbG_RT5LqYXqgA:9
X-Proofpoint-ORIG-GUID: 7NMr0VpZ9Rk0zTjZwzFFwssXjR_ESXJK
X-Proofpoint-GUID: 7NMr0VpZ9Rk0zTjZwzFFwssXjR_ESXJK

For failover handling, we must resubmit each bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this clone and submit each bio.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 51 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 4b7984e7e74ba..d79a92ec0cf6c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -89,6 +89,14 @@ module_param_call(iopolicy, scsi_set_iopolicy, scsi_get_iopolicy,
 MODULE_PARM_DESC(iopolicy,
 	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
 
+struct scsi_mpath_clone_bio {
+	struct bio		*master_bio;
+	struct bio		clone;
+};
+
+#define scsi_mpath_to_master_bio(clone) \
+		container_of(clone, struct scsi_mpath_clone_bio, clone)
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -116,6 +124,7 @@ static void scsi_mpath_head_release(struct device *dev)
 	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
 
 	scsi_mpath_delete_head(scsi_mpath_head);
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	mpath_put_head(mpath_head);
 	kfree(scsi_mpath_head);
@@ -260,6 +269,39 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio =
+			scsi_mpath_to_master_bio(clone);
+	struct bio *master_bio = scsi_mpath_clone_bio->master_bio;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_disk *mpath_disk = bio->bi_bdev->bd_disk->private_data;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOWAIT,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+
+	scsi_mpath_clone_bio = container_of(clone,
+					struct scsi_mpath_clone_bio, clone);
+	scsi_mpath_clone_bio->master_bio = bio;
+
+	return clone;
+}
+
 static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_head)
 {
 	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
@@ -269,6 +311,7 @@ static enum mpath_iopolicy_e scsi_mpath_get_iopolicy(struct mpath_head *mpath_he
 
 struct mpath_head_template smpdt_pr = {
 	.get_iopolicy = scsi_mpath_get_iopolicy,
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
@@ -283,9 +326,13 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 	ida_init(&scsi_mpath_head->ida);
 	mutex_init(&scsi_mpath_head->lock);
 
+	if (bioset_init(&scsi_mpath_head->bio_pool, SCSI_MAX_QUEUE_DEPTH,
+			offsetof(struct scsi_mpath_clone_bio, clone),
+			BIOSET_NEED_BVECS|BIOSET_PERCPU_CACHE))
+		goto out_free;
 	scsi_mpath_head->mpath_head = mpath_alloc_head();
 	if (IS_ERR(scsi_mpath_head->mpath_head))
-		goto out_free;
+		goto out_bioset_exit;
 	scsi_mpath_head->mpath_head->mpdt = &smpdt_pr;
 	scsi_mpath_head->mpath_head->drvdata = scsi_mpath_head;
 
@@ -307,6 +354,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_put_head:
 	mpath_put_head(scsi_mpath_head->mpath_head);
+out_bioset_exit:
+	bioset_exit(&scsi_mpath_head->bio_pool);
 out_free:
 	kfree(scsi_mpath_head);
 	return NULL;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 8dbe1c3784d2c..bd99ea017379d 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct mutex		lock;
 	struct mpath_iopolicy	iopolicy;
+	struct bio_set		bio_pool;
 	struct mpath_head	*mpath_head;
 	struct device		dev;
 	int			index;
-- 
2.43.5

