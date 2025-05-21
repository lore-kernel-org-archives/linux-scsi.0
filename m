Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE10D146A68;
	Wed, 21 May 2025 01:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747791591; cv=fail; b=HncNojLej1C4O3Pbt1JT9WT0Ixnmg7uNeQ/+UqK/58orUAyWZ1W1hNn5hkTd6p9jTC1sWrDU6BTOcsYKf5MDUErIod1hEwXUywRGFs+VIK663qdhU6RhKItSvIIVVmqKEETUJ41I0dxWRHrmDBmga6Rz633xrh2EGgJtjyt7w2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747791591; c=relaxed/simple;
	bh=+kHWKTM6o/MkBlRQRpt1Aa5drh/gJU8Sgp+PC4cpjMQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cmVf7mgO6bHVnEsVOnNkY6GGpilYFAUmRYsyNdvOtwdbsrTF2wPXTXm3fAq4dlWCKpV7KQdWILoJ5nAMbYUSn1RroPg5GY/xKfjLUW5nRLvda+KDipShfRYmjnpH4B0KgdBSFgeGR6vH+wD+irgLZWF7e1ItDuMU9MUbGerFNnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=irHUNv5E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hh3DNkO5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="irHUNv5E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hh3DNkO5"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1bMmZ013071;
	Wed, 21 May 2025 01:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=U2PXviaiX1FKiPQPCu
	cm38PE3qzhH2rgOvAqJBp3RGU=; b=irHUNv5EfX9FCwrik9JYJaJjPfH6oSCdRW
	UrMIPzpgFBt6cX3Uw/UnpdsmPfny7ELPEbw0UZjTQmnKYU+FD1dkOCnraOO35Fs8
	Ro/u0jfGakaQLkl1HqHIjWWisZ7i0kYtfKMp9bEeY09oMAVXHU0MD8x7AcQuPcAp
	UO6nnhNoS1UF2q7Hrf4U4n/mQExExEEE2nkG3lPps/VGay1BqlmVbWNad2USXIvA
	+JwlYJ0qpkEGtUGNyyFlBMvX663efG50pHFtqJZ8Ep3PAxAJOYqEBC0WhPwuqp6y
	NyZhXLQWKdNLNga07NpQAmjqVAYYgx9qyULpm70iSEhfM5UyK1FQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s5avr05v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:39:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1OPrD037648;
	Wed, 21 May 2025 01:39:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rwerrewh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vf2Z+19KRdvDm+GGRQiohy6MJ2gZPJgKegATGEXPccYYEcgA+lFfclKjZCYf2u+gQO/WdXZFlzMdNCbguv6LO1cHjo+qdWvKpfr9QHjwrD/D1heTgzCwqmfrB5OViNTMotztwEHB5dO+6wgB7VYq02yL+wOXCodjKY4gHSNv+VMXTb6P7Gd9w24EYEwzke6BKG0ZcM6yaszk7vhyB8LnEhOpAw95eeKGx4EaanuqoVsZSTTGsPvgzpnAt9tKkRj1ungcTdPwK29KdGscjAqc1A4ru+hQvzGPskT5NGWxy64dGeO1rH1NeIaIIqrE+IQ+Az3DIjQaWa/ltqqZI3uGzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2PXviaiX1FKiPQPCucm38PE3qzhH2rgOvAqJBp3RGU=;
 b=q8QWrj6h7sjq8m2Psirx/5ZaVfAMZzyFm3AociZ1sC2C5uWLnmkYVIWnXFDf5RXSJ6t9ZMfu1zB1hA5FdvF/p+S2gB0cf8/Mq/JIzAH/84gW63/x2MSUpe8xgTXhdqV7SWSwVkz51Xhpj4rh1EuhXx9GRKtDlZrhKElVxVVqobfA6iNoUWUG9uPJQOsAfcExm2FJCgGQ860H7mFCxLypv5aGTd7g6AX1AbNReNEebJfFqycZTeaOjhnUYkIdz1FX3brLNeb903nllkvKgRnLmI+aUxGE7vjZjc7NBFMroVh2utyxogljt3qL7E0jEb9F846VSGw1YlKwBGbfUBCKXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2PXviaiX1FKiPQPCucm38PE3qzhH2rgOvAqJBp3RGU=;
 b=Hh3DNkO5Wf3BZPnFg17gZ9rM6eaNa6m77BAl3yh46yc9RoLxtVmAtFuSZWNoVwQu1bnlLFxUQgJc6ER2Ut+h72WJOTik3hja5xNuav7y3ZGHhXIyoMCsJmqnJ0SFgclaPkYq2sIzsx58t06Y2xhv9NVAreasP2778NheSfOPerA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7233.namprd10.prod.outlook.com (2603:10b6:610:121::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Wed, 21 May
 2025 01:39:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 01:39:22 +0000
To: "ping.gao" <ping.gao@samsung.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, minwoo.im@samsung.com,
        manivannan.sadhasivam@linaro.org, chenyuan0y@gmail.com,
        cw9316.lee@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250519025559.1263821-1-ping.gao@samsung.com> (ping gao's
	message of "Mon, 19 May 2025 10:55:59 +0800")
Organization: Oracle Corporation
Message-ID: <yq1sekylp3g.fsf@ca-mkp.ca.oracle.com>
References: <CGME20250519025509epcas5p2bdc884392dafa224289b337c1232daf3@epcas5p2.samsung.com>
	<20250519025559.1263821-1-ping.gao@samsung.com>
Date: Tue, 20 May 2025 21:39:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0268.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7233:EE_
X-MS-Office365-Filtering-Correlation-Id: d32258de-daf4-4a8c-b5eb-08dd98084fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gcJBhdVCEzZSCzDtsgb6WlFAIy+j3Km/suhd4ZOm/UkpY+Cax65kdMAaToa+?=
 =?us-ascii?Q?ZKyoN2Q74b1oPx5Nlsh8MHmyRiDRh4XYs6Oa0MzhMveCsbnMug1SCkc9eXUi?=
 =?us-ascii?Q?ke6gX9Jbs72lJTMqgkAvTpBYcomHrJTiyCbqB9uteVv1dglo05vgAbw2AM6o?=
 =?us-ascii?Q?oAYsUIddDMYexgv6NJj8rH4qwdFD9ALnxN+ByyJDSrJQ4IESfsy7ufkpUBFI?=
 =?us-ascii?Q?dZkl8Y058xeDBs66NAumZD/9ZuVlWvMi/Qyfup+Ky229QwDOxGzWdRnkJCgJ?=
 =?us-ascii?Q?7nrUhxLKY20LwuGkKcG9dw7gK4adaaBkhJhS2l7ad1+oygywKdj6fjoXwT8b?=
 =?us-ascii?Q?6G9fE57nlqK/eiLbjYY+cszycvisFZ+Y2QpqxMFK6Gix8oIZzAXdNYWIkace?=
 =?us-ascii?Q?GjiIhr9jsZYpTQRCc897oF684Spp+MJcfKEI9O+iMjVJWR8RY963QvCWnlOy?=
 =?us-ascii?Q?AR5QPCJ9GC9hD1jxAMpJtBZ5KmiwO5WjwYMv8h4HVio4qrms/z0rPKuO5wa4?=
 =?us-ascii?Q?eiyotfzS/yN1LbG9hnPE7Tb8/gjxsnJPpJ2LTyA3YCtcr7frN47jggM6hVpQ?=
 =?us-ascii?Q?8pFZki83s0AG8n8WV6kgOWTOB+DdcTAkq/GCWc67uP7qpn8yZYNtXupV3gHX?=
 =?us-ascii?Q?89wE9Y72gFw3Hki0TPS4gpokpxQYZwsQMoPzkU3Gjy/RdWt84ziKMrgtW7g0?=
 =?us-ascii?Q?d4Rj3/XU4yPlhzQBtKNOk0eN5WDXmDedgh9wQaERvIDUR/k0DXp20TrQhS58?=
 =?us-ascii?Q?SuSN9mhJjtZI7n9I723usl0XZgQizEfXUjWkaq+OtwK4LTP6ycx+W1GyFgtD?=
 =?us-ascii?Q?zNl4+8pu5MCARzBDJlLD7o2sSBjxL75DippogFD8fGdRCplnKwI+ab3oQxUD?=
 =?us-ascii?Q?/M5VV6swFspSkFlC0TXEs5lfeUsnBj8kGdMkpN8Z/XTngz0xwImTOGu958TD?=
 =?us-ascii?Q?PF+oOHgbKYueZJQZbU2i23qu4ZqSrJVfMz5m5uRUq8yBV7tpOpAgiwAWHUa3?=
 =?us-ascii?Q?Wqh//pHJ/vQ5AhogQfe0c8lNx6d7M9zQk5YrFMvdiLA1Q5P5oRRaA6e1Z2Gk?=
 =?us-ascii?Q?WN3LP5A+FT4hILIatow1ixT8e10gjFUEPy8ldY3+uFX9lqwseauU7jkL6w2D?=
 =?us-ascii?Q?mupGWMyckt8fBriXMTbAPOSW/nH/pTT0Qk1fbCHkFx7QeOGH8kYRpXHXsIyS?=
 =?us-ascii?Q?9eFWZi0P1xcdNqu7/Dg9PtUJa+BGX0AYc/u+Rh+ZkAV368b0bdpQ5CJgwhas?=
 =?us-ascii?Q?NammkSN4aniC3318KK8IelWpJA8iXMImxwmzY5IZD5dyEsRxHroxGW/pdnPE?=
 =?us-ascii?Q?WhDcGmOMSWMXptRJ8/m3foYiV3rs0+4dIzS3c54pxQWummP2tqoU93g7qYq2?=
 =?us-ascii?Q?fM/wfsC2Dc49UnpB3tiUq6hTdwEGZh6OQeCVNuUAFaYq3E5Ky0bb28Iw9Eub?=
 =?us-ascii?Q?Gruk+WjTfYc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lt9L1AJPsdzx4uSHErb8YOYgmFvphOPqtxPCqd85vBU+YOna38o4M/vlWUgr?=
 =?us-ascii?Q?xsLa8bWi/r/mZVPuHRTWd+gcBdeGsNNa5qTQdGk4Tsiknobl61USwlemD7My?=
 =?us-ascii?Q?Tos3WBZE568Un7dWdFvlXssINk87iOxqbySqawCA1SSTS7v3dDzyTzyn4PFI?=
 =?us-ascii?Q?yyKshU/nnc7cueRw5jhvi/bjSscj5orC2AwGUrSVSwIbSa8I51oAYJHXWotl?=
 =?us-ascii?Q?tiXcoZkPD5NxieRKhqQTor7ZIr29Ic8ly69MqyMSBTxmbMTa6bbqT40dElj4?=
 =?us-ascii?Q?Zo3n2xgxEM/wtHfD7qsYomNnWl1xvk/mPjGQeA2yX3kEiTuWEXJqtevKMlde?=
 =?us-ascii?Q?ZWDW1oVeASoNXRc755TQaW9isgfOmOInNMNlSDJlFqmyvRwFK8sMG96VNUpu?=
 =?us-ascii?Q?yww5FhZ0F4DCBjnFbOQG3YtNfBfsJ6pSg2x11BJ/LxD0Eg9tEuO6myoZKVyu?=
 =?us-ascii?Q?8XhkA27mbvvXmQscmUA8+RR2Z5ZrvjG15BcW/3BkUQfHBs8VxEeMgnvUqi5b?=
 =?us-ascii?Q?Ij2+FiWWhx4zSVz+1l2Gg5t3RbrOAJokgE1/z6U96GMvmaiaAZrAp8bj3cfE?=
 =?us-ascii?Q?mYagKRqmex3KggLTY2UDxyG1g3VGnAODdjd3RZ8fL7E6RcKV30KJTyGEeI7W?=
 =?us-ascii?Q?gI+EmnGSsV24hEW4OscwTMS5PCkpsg06JcIlKX5EzVSZ4zC0kedDE/3AuVtI?=
 =?us-ascii?Q?FzhE6y3FqRkY10qzEQMG+59HYMPz0z781wCMS0bYpNQFic5ZivxoojflY+F8?=
 =?us-ascii?Q?5WikJZfBDz/z0N+2ziia00x8By2JMXCs+WVqGwWyTlLTMeZEOVlxBvxdG8ye?=
 =?us-ascii?Q?BBx6P8XvMPUqZcbRqLm3VQr0YMguIYTb9kuzAkGf92zltd3zrQ3yZO3fLlDN?=
 =?us-ascii?Q?YFoqRByfkG3m/VNYMtoEJFZeFgpTgKvOhoG+ZJND+tHLi6sZvEHgPeF9BpYh?=
 =?us-ascii?Q?5yfTjTQbyiP6n70ugsSg6izlovEHxjV4e7ZsulKQB7G4PRHcFdCFSFOw1hqp?=
 =?us-ascii?Q?Gyzof3kN8TtYwX1syzIsG/+N/NMRlPI5ouC2iIFjZsrK6IBrap3rs+kXkj2F?=
 =?us-ascii?Q?h0d4QxZ2AFOq98nJ6l4NVbLkdFkWsKIG+vvt1gXTe8XrHbUxT1R3vu+C+4LG?=
 =?us-ascii?Q?l/81gKzF3GtymdsLGpJ/yuyCrsnUOR6qE/pkv6Lp1GW8h4jC0B4k7jXchT2q?=
 =?us-ascii?Q?SMTRQR4uMjNyTWrCHqd6nx6hO1dK0QG9HPukmR0PZXbidHCkIsw3IFS76BoQ?=
 =?us-ascii?Q?WOuBtJFJ2+2G3q/gHavDKEeLXz4udVvw46NyMusz5QnwctxeNc2K7F9NKE/E?=
 =?us-ascii?Q?gpdXEtjR+DJ+jAvBvenMWosnnpkGN9kFb+SRmZQF8eEiNrJeVslh+4xJ1zu0?=
 =?us-ascii?Q?5KUdVnknbbtDkLMelXtvMMVtd7JKF6m5tta169NN7rezOc9t0whFPRkEqGke?=
 =?us-ascii?Q?Jqx4iBmGUZ19VTl65Y/FkeGGAcs2SoRHh4zKWtG+6vaAkrarj4gMqMXY47mh?=
 =?us-ascii?Q?5ggwuWcASFIhc4N91es2SQ0BKZPBDsKO0lx5O1m+6k/2D5AUJMKscTvPh1bt?=
 =?us-ascii?Q?mm9KxDJgxxekluRADjUNoqYKSI2zgEc2s7ra20Eb5DPRiR0T1+8BA4CABk4m?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fdBbrcyOyeiMo0rbD0jEqDs3LTdKWciRwVfJ3xf9WzedkS9HTCsPtPwON8vlThkDd78Sv1Swa4mCjhC7Pkz62QT4e8IJkH2btS2gA7w9VtGVW9pm+CehkWjA3hoTqMNAnsscmuRjaolJy6prKEySk5+UV2vSGZkGAsn+n6Y0NI5wP3YFhNB0h1UhhzKAw/jc9MqTrAGALCIDKCIXw37uSzePULbl1tXsTOki/3eD5FtCIyx9WT0970993Hf0iKMjnF2WbVp6vLKCt0k2r/aU/y6VGyoFdHRmueVgmcExcuTLCJLOR76RknEXPLpvvKZ27B8JZppqrxmQtRHNnMkFx7wIzB4sb49hHWjmiJC2FVCwo/14phTR0eL2jGijLV1kgfITDWb7PkNyAXBHzhN/M4/ybkvRdKCVdhOYFCbUGtShlJBlLhk8mvL6WMn+Htor936+uheM9NY0zAiOamST1gYhrQerMHA6BQrhv8ngLfKY6UMQwXhQOU1Qpw3LMa7wrey5I/H0tLLC1NlulmGOUVGd5VIOqNgFrDHB0godSA+PpK518DF78yyBA7b0KOVtMZFW644sI8fRFJBIKfaxtmvQC/CfIQ6s59Moh4BqNIE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32258de-daf4-4a8c-b5eb-08dd98084fd0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 01:39:22.4492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FmZWJ2Dzdk/UffwyR3V1Wz1RT/31OU0uTNEpFp8+N6+XmC64Go0w9IqB7Yfksp0TE5rZ8qMp1XOVFaEoXWZ9aBfZHkXkO0O5pXFa0k3C9Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7233
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=877
 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxNCBTYWx0ZWRfX9UYD5BZgdypH 94P9KXp4P62Q/AvOcgqZ2Fq+VrvJhzywC4MgKlcKiNPMsJDovEptbFnTehtbLIEv88lALMSWtDZ VbgLD1jFSwqHGzJv5fIYcwYzmOd4JB/nnLVyZbBhsiRkf49n8u3gpnBDmZpBuawTCI5+chcZDzQ
 SEVkD7jlhwTQwNb5wzptaUHc9gnTTK72v8+qId6QXNb6KdAvgecNnB8rnpjT6fHAZSuHnmDjZ/z +djEi472YxuB45hvktebWQMr/o+U8OxN42tyX7aKvAojpKrXHRulmyjzl3B8Di5UbuwP/hLiOCA 3+Sl0igpISoE89ekvERTiNM5RDhRBz+AcUFpSEz8u9IFYuwcuQRbtbcYFe8jNpSkDbfeR5KJqhK
 stuWBEIZyp+UvupEZy68yBxLbKPqF+XHi6Tm+Ny4OY1xbDYE68lxDb2rNr3djveEUB53+mFR
X-Proofpoint-ORIG-GUID: tGnovscX6lIkkZmfVQyVzhz8LLQpHstE
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=682d2ece cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-GUID: tGnovscX6lIkkZmfVQyVzhz8LLQpHstE


> after ufs UFS_ABORT_TASK process successfully , host will generate
> mcq irq for abort tag with response OCS_ABORTED
> ufshcd_compl_one_cqe ->
>     ufshcd_release_scsi_cmd
>
> But in ufshcd_mcq_abort already do ufshcd_release_scsi_cmd, this means
>  __ufshcd_release will be done twice.
>
> This means hba->clk_gating.active_reqs also will be decrease twice, it
> will be negtive, so delete ufshcd_release_scsi_cmd in ufshcd_mcq_abort
> function.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
