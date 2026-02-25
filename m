Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571483D649B;
	Wed, 25 Feb 2026 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033607; cv=fail; b=cw3YQTLViAWXZ50heFZJPtJpm2nGwhUKH/uLdjDCh5ERPQvbvFJzSPHqJvR8oCje4Ruvp3OuTyAFdEkNqZ0ijfQRvlxn+oROaBo6iBukIyjbkpVLYXHsjuT+s8ek6PoKkHivnvF7jVwJhWxPbRcR0YaPoLR5stTxhikUyGL6Y9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033607; c=relaxed/simple;
	bh=8pc4Iu0qOyO1YqKD93l9ZsWqy5YktEvI37wQh13dVrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gcwidcMhQaDVOwSA5yYhVzjRXEaAzbkMpw+aZ6Gic7QdspEgNWIMQePL1bGaDFBVzosCz9A3pbuH+NEln27dLD2DvBKIxvKjBddFaV/3cFefewk3Kmz2zmoULVINEK8n02h3fzC5C9PcY3uHiJ4i2tHCXn6triOTO9zbU9cedYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=STiJ0uqR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sEDdXaMN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="STiJ0uqR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sEDdXaMN"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9he5u3930646;
	Wed, 25 Feb 2026 15:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8bgkxkOpAxXofwMgNEijDrPvW0VSFV5mkZ7D5lEm2HA=; b=
	STiJ0uqRy81teGs/tQScVwbkIVEEhCltuMC/ohJ22XwZ6vFxgEZg0aXaRDXI1mAq
	xefLjT9yg9O8KmlA9Bj/jlsCBHrtqAHuAXmfIu+7O8IIBqs2lH9713/INNB1YA1r
	NyL89X2JBao32E0cRf6rH8Wo+Bb1UhV3ctd42Vus9M+vXvORKZ3k9sa8sZeQrE/Z
	1OcIdzPslZyTzZscSJnyRASPLxxS1mtVsl5Pgres1xzowe/wQ1X2ANCKIRIWCYcX
	LEatC7ThmW9iLuAW0y4snIbOpFGlx5OIvL+VFJll7ZQ2mbJwtk5U00F3UN1v4dop
	KjYB95lJG6skQGiNhoW4kw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qedkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEXUdn013310;
	Wed, 25 Feb 2026 15:33:02 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ffugs-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZCX5LYPoKiTaK9PrkciJmz1X4OyiDvU+tcrMx+o2/pfHXzyPQ6lU1ZerhRtw63AiNT+3z1bxUdjJZcPwm1RhorY61NNafSuhlH/X1xWXNY4lnjxwakWGZjRrF2/2XH9gAX9mWG4cKm8fAegis/hj3AaoCDGJWi/QOs8/00ZR2YkkY0jRmqsOdpJtHMl2MNqEXxb0l33wi001Pnfywx/2RaAT/NYNlGM9xfLmD4FDsxeP3lyLzFf1fORGCfL0W2VL1oy0rGE2rLvZ0OG7CteOZ7aX2MalPZWy/9oHpjiSJcTSlbPZewfnKPqd1+l/u20Uh69+Qr5an5KuR9yKHuSfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bgkxkOpAxXofwMgNEijDrPvW0VSFV5mkZ7D5lEm2HA=;
 b=zM6UYl/7f0BqLvuy+z7WLPBkx5/brqL3J8Ux6t4k/XkN/s8T+rem6W/dO+yaLkwo6lDLIEv8u62gc2WhA3qEmC8zRkqhoh4hdoYZLKx83PUSD+EPThCyorw/8iUyYoXtwDslPsahXlKn4o31hRODb1LFdXriaxDFzEOv9ePDYJszB0hNNUAC08bOgToAo8CAwuxnxfGmHVJi7OsZ50eudNYu/Ei9vys6VsjPrVvHTk7l6sjdlJf2UWwdeI2gPijTmmaW3ZIA3fk7+jU90N/VDhrWhTnwtvCepy39dXOl9LKGges1Yc6NS1KJ/HS6ieOuWuOkwtXV38sM0T2M4MiEIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bgkxkOpAxXofwMgNEijDrPvW0VSFV5mkZ7D5lEm2HA=;
 b=sEDdXaMNjtfHsKmeQU3XUPZ8XngGfeI8FmORcvS8L6x0JwH2Wu47u31IpNLpnCzKXEFJmVY2vjr2zjaVICmmO/03BcoC/qHde8BscKFMsfQ/qWIo9lE7YPYaDQMmE+QYgUoQvuWIYdKPzkrGDdNklhEv215Rp5R6Ot8Cu/YckJ8=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:32:58 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:32:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 04/13] libmultipath: Add bio handling
Date: Wed, 25 Feb 2026 15:32:16 +0000
Message-ID: <20260225153225.1031169-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:610:b0::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: e38c34d4-50ec-4d72-0579-08de7483277f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	kuqnaJBDkm+94QkuPnEKV4TmvLkc1BkENl2mR1VCKvaCdkZEU6MPskbHtbko5DhwF+xr9347i/Pgub4Zxo3lxj6fVufwST1s0kuauitYSUOgwsLhICDAxO/F77Gu+aCmwJntjvlIGJ0fcsoJBuWiBTY1beTkuSXU6ag79tJLNXgpDCN8XxBZQH1vk6Wih6e3UFRDO4dGNEJ2HFXmyGOPPlxGq2LMane5sIsf3Jq6TUra21JpEKlp2dAvspOkQEmCJlNu7V0kRrnTUrrfZdo77zPx4t/06Tqo8T/WVkLfTjly12YBs1QJpEURolWJZRZdlPzainpmAzjFnv3AozAAs3lff68xKHn0NE9SkujMyGnqpardB7H1JOT6WWwIA/efLfc68KwrRv5qQYul+yhNxy4yy/ti1nCDQhn5mAsPF9/aHRNaEZt6pkzr8EhtuCYHRXdKppAOSzq/SiZgg4gmDCKxDKWU3YWADd5+hbnyRPgDoauZGYRZs6XpG5bd/BnHh0wd4Xe4kKfhF9uBEvadil8+gFV2kKFjRrbKGAYZ2nVHGPLlgJD7YeB3Ga3nws5XY6IhV+1U9oKtknodlMxSgyIM9k45ghr+3e03cPk2ppyoXS5ZTyoUqGYRAeUVw6cJMaAMhKmp+snDakabvpK5KY3vEON/c44AeP4LqwDSD1SRt6aOtQ21Cwo8MWJK1WN62rFieToz3qv7T5jq5r1vRTPG2S4izzwHFjqFOPKyc1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HWP7bOwsewQZoYhAVve6vrEhBFAXn4Ej8KgCtzmqPDWncgAeMN1UYTaX69zw?=
 =?us-ascii?Q?ySVdIRB6zAIE22g4c9K71LH3Mcw+aHVICwgqtW66Y46gpeHbqiUdXR9I9J3V?=
 =?us-ascii?Q?85oUrHWmuboTIjTNqZ3uxeKyjwT5el4a15elgWBsvdw6/wyK23+pj235ATG0?=
 =?us-ascii?Q?jDRqxmqd4ahSs9hsHp4JIYwvp7fmWYqHEvgdweGeWpmAbCKESUHYlOOEP5kt?=
 =?us-ascii?Q?WaDAdOedjqUYHXiM3jkIuW+MFT93xuDOwJtNBIO+3g/3dXaItFtFQQTxfhEA?=
 =?us-ascii?Q?1FRDxWgemg28S931RlMurFwVDU37sT8BYAJDEAJZd5JuN2DdJxywCa9QBI6w?=
 =?us-ascii?Q?5exxYstWZSDvShJh28BwH4szEA4gX94p2h4Zrl7wTmT7tevmvuf+ulUVthgo?=
 =?us-ascii?Q?hraWw1SUM5zuW5bXK5Xc+qBh4wj/4FLSY1zYOVXswvUHmChhSXswh/sBXLBO?=
 =?us-ascii?Q?MRqVEUpzN7aHMxSPERoJqzBsVwmZiyiBpowks4vopvzhX9q5vvWKYwKD48JN?=
 =?us-ascii?Q?25AEX0ItMww+2fMXjgnrnhpKv4k+HKuGuUJTUKcl7yuKufN/tYtjHBHcF4qW?=
 =?us-ascii?Q?19eIBEGhjbAsXRQ2vIxmdvSWoXGKEhJZa+vvl/oowkK7EYLZIYhOZlMBpWKZ?=
 =?us-ascii?Q?UlEp+AM9SeZa6BmMkXEDkx0P1O3cnrCaGTBgSCuKzIMH+9E9+Rr20gLrttew?=
 =?us-ascii?Q?uNMB015wwGhD3/wagZTYIPpMjEJ/tXhgqJbB2+1iPDkO85YfGJBFYekxySk7?=
 =?us-ascii?Q?jEcdF5UijvaAvB1c1tDVawtSC/k5reiePr18xSKuDwkQ5S9EIn5QWfaTNjqr?=
 =?us-ascii?Q?cpC8x1XpNTWf5ByKfCYXxhOMY9hxrumQjNaC61LQu9IozHZZZwcVPZdV5DPz?=
 =?us-ascii?Q?zmxb96FLbKCn2GbURSQBLzg4sGKIw9BGI3Dycy3/tTpUqEyDBN4hHTDGFlQt?=
 =?us-ascii?Q?TqGSk5/9//Hg84F122xerr2iGWqt0Xu8/0RjHeK8Q1RNcxfEYoxwTJqAHTPv?=
 =?us-ascii?Q?jwmcSZbZn5W2JobATXhLbNX1ecRkHtqZgRwINEXD4QNKRjEpZVkT1Veh9ihh?=
 =?us-ascii?Q?H9hjBCQTQAGpjyQXY+RCXLs8EV7pY39ELWsyDJOteMtDmd8xot4mY3n3NhFY?=
 =?us-ascii?Q?GRQrcNY53C9+MqEPE4zQx61WsN4ea8VoZEyZr4A3A20+tdXOxr8jBKKOPetZ?=
 =?us-ascii?Q?tEDVQJu83KnXNGBoSGlRw+XPTe31WOWowqRxklgMWBWP/bBfhfSW5IWS6Txh?=
 =?us-ascii?Q?HE+DR2crZSC/Ra+2Hfs4HrNGYWouvSgDHa7Z6tgIZ0r+6TjICCXJ1MfYqrdG?=
 =?us-ascii?Q?FJutEQFBToibIZuOip/WNDIcpix+2eWtbDDU4Em/Wtaa2kMp7pKXt1UgSGyn?=
 =?us-ascii?Q?Bxx2MyijFp1ezDw3FTwuDE5aX4u8sS6fZkhwKETPPH9UVkPWQ5MiH5fHTbeV?=
 =?us-ascii?Q?0xJNmNx7TvppC7YVtlkewzZO5CIt9M8cMJNNVj1GkLPgq4chvlf568ruPW9T?=
 =?us-ascii?Q?/VPzvYPzvcJ+LkAcjjfX9ETLccX2YVhnvdt0BNXP3aWuQZy3NozKxsbhMgqc?=
 =?us-ascii?Q?YSSQTZmbc3jFuGYTz71338lqiYwBoCVoeNw9o0/g1RkNFUoa2D7xoGORu5JZ?=
 =?us-ascii?Q?2nxyKezxqv5Pr0dk8WY2dUcL93sckBmrCOo9mbzOvgY5J92zCQOTCHeNhME/?=
 =?us-ascii?Q?UIhW6dSG773uJ9J79Wr9rLvDxFZdhzPtSbEeNkoQcHGQV3dL3LqbLPnvfAC/?=
 =?us-ascii?Q?zf5V7lU6VxVOecSa55u10Wt7M3TL8I0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1v7uqsY0IcZy1jv1ts8mKpt/Jb/KRKiJK7oCCp5auwdjEYt7QvXG9hm3Uvl2Nvfn0qMNEM+RYwWxoGqByLFgGI3AODRA3gsHVMqU0GDFVQa/DahzyXtNJ+zBx/VldcBmlfEzow1cchU+SKDgmDRwXj2j7Bg/rAd0V6sMuOAFAMPsnpn+BPmGQFg/rj+i0iYSU0RDP8jjmky3e96Q8ga9YeFDmYbM+hHebOwvR5dJq+21h8YbbVXVHv5lbjTBKUrfUbHq10Vyth4dhfUlgBNWgnwuxZnE4z8DS92rsiQ0xAeMHqWrtdueSZxT4tbaP/egw4vw33qJQZZ4rv7xPfxMrD2f3RMcfVIST+YjjvuXz1fAPcUVj7YMq9q+ayrGb158ZW6guLgFKV/r1DL38At1dbmS13kel3KqQusP1Q0MtvM9CdrTxp93kYhqVILHoKAHmh+VLk+rz0yKnW6LITQn6pZTn3NPRAB2Bjkmgn5ZoHXWsA1iDyOFPAwaQsGov0wQgAk/QtmXN7Tzl5yypS4M9y6+EvxTVM9we1cy+JJMApdRi7gNP5+i5e8PEUeo6mQcPd9bTahYxysfgqoksjDfye5RLoPzswX338F1XzvVzoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e38c34d4-50ec-4d72-0579-08de7483277f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:32:58.7212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AL01aT0PYjFQ6nUDMQEpuHi4JPQ37FThGU6rUbwLP84xVvgsVUblLYV3e/iQaFjaItdlU4tq2/ouKHkQ8c1cEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX3THsq/mEkqjW
 eMXkwfE5hdL40wJFbk8GQxq7OYxgSEgq31EjO1sd3yGUXzhBhAPP75uQOlnzE8jcUSUvX/+XGnB
 AtDVdrol85P1qubPAPW5Ctv3oECmHq+qM250QO1ixCpRL0uKW6Am9WQ8mZjaeSpuru4vOcO8Lty
 WCucSEUnxExKUlbLSZFDbfq1xKNTNNLpF9uA1pu0ryYw5jFCsfsl9nX8El9V5CqQR67phws8u5j
 0pjS0XCDLNxQjl3/pb5NxbyflN14qamyJBE/h4d0EI0rh7PlOccVA5WDQDsSEMg6qiMu93ifPFs
 deu22hRFscVWi8/uzEulse16+Nov5KgBljvF4hSaHakuRFSJbv9ZbJNWZzimxCZkgZZkW6GAU7A
 KsA9yHumIp5ARoPzvO1qlXz1cE2ajYuf3QLiBhDChrcQNwVtO2cyRZGOcW070+f1cwW9+wW9O3h
 zO4z8QNBjKHrgGIY6wURUE6fLthwklOjP/Vr+NNg=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f162f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=yDs5R90Q5YeJ1ekuL_0A:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: NN0rysm0_gkMpQxnMDRmGXX-V5DP7S6A
X-Proofpoint-GUID: NN0rysm0_gkMpQxnMDRmGXX-V5DP7S6A

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 15 +++++++
 lib/multipath.c           | 92 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index c964a1aba9c42..d557fb9bab4c9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -40,10 +41,12 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *, bool *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	enum mpath_access_state (*get_access_state)(struct mpath_device *);
 	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -56,12 +59,23 @@ struct mpath_head {
 
 	struct kref		ref;
 
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
 	unsigned long		flags;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 	const struct mpath_head_template	*mpdt;
 	void			*drvdata;
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_disk *mpath_bd_device_to_disk(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -82,6 +96,7 @@ int mpath_set_iopolicy(const char *val, int *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
+void mpath_requeue_work(struct work_struct *work);
 struct mpath_head *mpath_alloc_head(void);
 void mpath_put_disk(struct mpath_disk *mpath_disk);
 void mpath_remove_disk(struct mpath_disk *mpath_disk);
diff --git a/lib/multipath.c b/lib/multipath.c
index 65a0d2d2bf524..b494b35e8dccc 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -5,6 +5,7 @@
  */
 #include <linux/module.h>
 #include <linux/multipath.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -227,7 +228,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head,
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy =
@@ -243,6 +243,66 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		bool available = false;
+
+		if (!mpath_head->mpdt->available_path(mpath_device,
+				&available))
+			continue;
+		if (available)
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_disk *mpath_disk = bio->bi_bdev->bd_disk->private_data;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct device *dev = mpath_disk->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		bio->bi_opf |= REQ_MPATH;
+		if (mpath_head->mpdt->clone_bio)
+			bio = mpath_head->mpdt->clone_bio(bio);
+		trace_block_bio_remap(bio, disk_devt(mpath_device->disk),
+				      bio->bi_iter.bi_sector);
+		bio_set_dev(bio, mpath_device->disk->part0);
+
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 static void mpath_free_head(struct kref *ref)
 {
 	struct mpath_head *mpath_head =
@@ -310,6 +370,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -327,6 +388,24 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_disk->disk->open_mutex);
 }
 
+void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_requeue_work);
+
 void mpath_remove_disk(struct mpath_disk *mpath_disk)
 {
 	struct mpath_head *mpath_head = mpath_disk->mpath_head;
@@ -334,6 +413,12 @@ void mpath_remove_disk(struct mpath_disk *mpath_disk)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_disk->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
+		kblockd_schedule_work(&mpath_head->requeue_work);
+
 		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
@@ -409,6 +494,7 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	kblockd_schedule_work(&mpath_head->requeue_work);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -424,6 +510,10 @@ struct mpath_head *mpath_alloc_head(void)
 	mutex_init(&mpath_head->lock);
 	kref_init(&mpath_head->ref);
 
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
+
 	ret = init_srcu_struct(&mpath_head->srcu);
 	if (ret) {
 		kfree(mpath_head);
-- 
2.43.5

