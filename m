Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC23128820;
	Fri, 24 May 2024 08:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716540541; cv=fail; b=Usol7TPlhRsEUCbPrKoNCadqH4eQ+EFigH237MxoESt3100HjThOylceda6dCMZy3jD88Vq29apzpuGlj1NmZ4CQtuXoBXkEnqsnuamI54wIAc124Hdt/KcBK5FxRR5aTlnzG99VrZvJ/oLbnPYPf8hgzrC6xbbTD+M1L2xovuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716540541; c=relaxed/simple;
	bh=W7b07JiGNVLMKQe3/tvbE56af36IyksZwwFibALYGeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q9XWrQIBAfNh5QE0BxL6EsHnaCVewZLOmm/R3Zip8HxQn21ckkVb6SlwP+L7MHJj7Cyqrn74AM+ffXh9Z5h5ahsvpu5Abv2RHkyrVFvg2zYM42S4MsaadyvezHyDsWYkC2pGFDxtuNS9RD/xfFH+QxxRvpGoFgyFyo5tmuEycZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WzMOvuqP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jf071dS1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzMOvuqP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jf071dS1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O8iQ7X006542;
	Fri, 24 May 2024 08:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=qDauJyWY+iLrnbwQxqR7qtOmvaukpKzOxwYU7XWmi18=;
 b=WzMOvuqPAsAfrJdLMfPQWjzL0HkDJb4NsS1Ox3eSh1MTWKR4x6ETArJJuCTI+wbtr1b1
 5jL1VG6o//ZVCz/6BKWTcepbcdSp4zL3KgYya+KhTfAIk4qBwaZA1MGPu95b25gPKkoD
 IPMXR7Ixoj6zB3AuQ+ZpQ/VUQ4gxzWHL3tZf+/tcnpXvvoQqC9KiXLVDYx86me6bY3JK
 mTvTflqQAVGRYIfTOidf+/Awg9YqPDHEDx1R94qI8j0Lojm2fNnGkb6+lGGoyADV6qVn
 G9eMYYCCRpE0/0YzEHNO+snxdhH3yHiPZHaR6l6Ck02/UxgT5QeLNB3TG66L34oB7p7M 5g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7bbku4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:48:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O8KJwj013839;
	Fri, 24 May 2024 08:48:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsb2j7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:48:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyU+PT3HDqsAZXybIuFll33L2cXVQw7XGPPlccgzRypy89V9LFkkfGLcAom2oi2av9VsQwKXVp2l6VWTvrQ/YPtyS6Pm4PUm8bXZAYBhsin9fMEPAFkLHlOj7QW08eCaHtbDYk0R2NFG84zAqJSrMVewdfXgo/Gyg6aIApRG6KwLjPges03ajJMqA7gwrVo/MVmGkz2hQmZvg+2ZdevFwVNOyBnLqYmzx54FNbQ2/N5A7+G44UuGjRQ0JXvxQKBOLoplz+6dE8xFQoxFrE90zterAHdZ4T7zvXo7CRDon66xGDb1BjlEFDz+4h9YRurZzfSdMgUw5mZyDvxIeYWgTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDauJyWY+iLrnbwQxqR7qtOmvaukpKzOxwYU7XWmi18=;
 b=OS05zg1q9yu2dPu4ROP2Ku+iQVlE55UHa0Z/ra0YaW/c7kxmZfbjctQfghOVhZEiOVpolsPO5mM9oVhaocRgDN4QftL8lktuu2ItckXl+3TZlvWJrzwTgldmNxgbOF0E6dPO538X1RVlpQrCcb+1dairOTN48IwXIEQj69HnUS0FUzNdzSiBGwesbRZM+KehlRqJ9betUwtny0voHtdsIwzn+Zd4ldGtEG9fL+l9UFb0RXEtVSqeRd+ql5dj+kA7PBesbMqc+DkPKS7JAvHAlCsUgjermmZshg/GKvjBUttseluRTIjtwzj2Bc7jiuYWu8YdEjZk0ortFkvo/aBK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDauJyWY+iLrnbwQxqR7qtOmvaukpKzOxwYU7XWmi18=;
 b=jf071dS1Wa3tBHjZF9BlrbsG2Oq6YOa/4XPLP/o25aMJLcKhFhHQfxg5A+mlHv2QNKh3i09tySvOrJjnI+MC2bYpDOkyu0FvPHxpIgecOlbOZipngbHqfko6h7k6g+RYSLyffE3ehTRW1GVN6C5JqMZRZJl2Bfwxqs7bQ2YcVNw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4357.namprd10.prod.outlook.com (2603:10b6:610:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 08:48:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 08:48:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        himanshu.madhani@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] scsi: core: Pass sdev to blk_mq_alloc_queue()
Date: Fri, 24 May 2024 08:48:28 +0000
Message-Id: <20240524084829.2132555-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240524084829.2132555-1-john.g.garry@oracle.com>
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0044.namprd08.prod.outlook.com
 (2603:10b6:a03:117::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dfb646f-e083-4f56-bf34-08dc7bce5616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?JDQ1xi2hy0R2QJKos2CG/ifYVpXwbibWReyhVB0traifeMJHryq6lCWOE4SA?=
 =?us-ascii?Q?WBUXmPwY/n95nGI819ql1VpzPWXrNYE8Sl1YXX8euIjvHumTm89mF5vJ9oI5?=
 =?us-ascii?Q?CU3nSKT4YIUSRF2PN1atS06iuYX6nznvThD6tRUxzLlSBIOMZQsHIQz7GUq1?=
 =?us-ascii?Q?l6fOxt7zqTyC/mLTrI5BIpGMoqat79Eb9Hp6kw1h3zah4KVwRwATfptrSX1G?=
 =?us-ascii?Q?LfTbW5Z7XwvZiHfEEa1W7EZwjQy4vezg7YiHhQ6M6DHWr0Lv9w+JsxrlvC55?=
 =?us-ascii?Q?p6IewFIDY4MvyjD2MrSQ/RBEzV6jNnRMsZYL6Py/fa4xZlK181EaVpILqRue?=
 =?us-ascii?Q?j+FrAIclXJdrcr0qGz40BksUrffNwLRTUpuYREHZWBMKxFAgnBLUHvxg6wWq?=
 =?us-ascii?Q?gqVI2LycAs4DsNBeGkpldk7fXB+K1du1UGm2ra1ga0DeXCcR8QBIqXb6HZng?=
 =?us-ascii?Q?iIrckFX+Ia2X9us6L0XogL8+3kqWFf3ZflEghpcZBwr9cSKS6fNJLg6vvV3Q?=
 =?us-ascii?Q?HeRm309UTmQeXwUzd8bL37NITQLt7HwW9duinuJscqJNeqm05wEa99Q8Xatc?=
 =?us-ascii?Q?OqP1hpjZP2lwkK3aGHLjgJQNDznzbF8+hDiJiPSGz8GTmoIl0SkvcyopTAeu?=
 =?us-ascii?Q?oRGLgqBmn+XgmWftRl4jPwH5UCGYtm/0RNnNOBTVePN9Z9Xtr8kgVdZnsEXa?=
 =?us-ascii?Q?agF7dFurdGDILQQ93V74CC96izCfyIPexRZfecRO42mo5D/MCnpxOOkjAH3v?=
 =?us-ascii?Q?ECb6+D6TBC+n5MidgAi0x3ZsH+M7Th+08Wcvscg2s3GUBbKol39ALfQGhsl8?=
 =?us-ascii?Q?rbAQ9RyyP7+IiTrvQ2fi+5qUHzK84MY2WRtFLQsf9CP5GIk/PiPPPVWOgk+t?=
 =?us-ascii?Q?SZcHgrghHX2UABksu//1/Ho4X3i6NfFt/usSajSh3pLY5MnaCVZkVpBaTMCL?=
 =?us-ascii?Q?WzJCnXUgYFrYO7+jib3IaZSoL2i6WLBW5W9MHCM6zybo7sUTFUFruZXyTUxC?=
 =?us-ascii?Q?0qL0HA+R0FG6oSVxElANeBsDsWSA8PO9f/qzWSjwCadyIeKd0XpvFl0XDtyS?=
 =?us-ascii?Q?1NtpZmVeSbwNMzLu7SgYEDKhcYLGsgj7ubhsHqFckPbCWwL3I+UXF/t/oW1c?=
 =?us-ascii?Q?DPeBnoXzfTbrhfaM7u6b/OnFHDVoTK99PBSp2Vh01FtnwdHZ/+2PAYlS8DHg?=
 =?us-ascii?Q?R2Wx0XFkmAw1RA+UTHMKO0KkMRpdOjk8pJH0FoPjxloXub0oIs2APDo7q0cO?=
 =?us-ascii?Q?Yc4py6RrXlwzuIK6khTIQHFHNN3MuWzR1HkEMA1P6A=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?olpqbyD49ip+MVCYipe7TiNO6A89NOxVUHlY4eN17UMxlQYvHlS0lvZxP6q2?=
 =?us-ascii?Q?SkUcil9Bwc4XRz1P4bYJYQwqCkW199vZeIAidxHCioDKp8W5kt3q6j8mUXEg?=
 =?us-ascii?Q?1+FwsEoThMd6/hCJpy7LOiOJyUBGTlv1zgtHXnuLIPPZwVczVoKiIWh6x6nc?=
 =?us-ascii?Q?J4aEXULOPNuwkMMEnn+K+reNjP/e1mM9w4BXqPTTE1Q1xwO8OIgo461/xHA/?=
 =?us-ascii?Q?8v36weXeb1OLogu+LBqOAZD1ATHKmXCM+GmJsB9vyalOPqo99HLyw7wK9Mso?=
 =?us-ascii?Q?qh7gpFTaFHEW9a4vMm0EWL2oElWWd2YptxTvaskedO0h0A+WR60bQySI2XDM?=
 =?us-ascii?Q?Bkxq4zwRv79J2R/QbJxxVUZRKkAUvzx/34XsBO9QjfSeUo2aF7e2MnNPdWRQ?=
 =?us-ascii?Q?RiWh/dT/xSr+Q+/1uuPhxTKonUjCVQ2qDZ/exqPdIQ/wg9ePi8bzpwvwqaZr?=
 =?us-ascii?Q?ce7LX2rtIVmQhlyQ50ztYjhfhFEWdHpMQxKsRfvPVf3m4sR93DINrYyawhk/?=
 =?us-ascii?Q?mJgv4o5J59vHXJHkx6aE9BnypTSt9IEVQ1U4T7FAmhrplwVF/5j8m++KmpEP?=
 =?us-ascii?Q?lD/Rmgl0pIqEFi9l/IQYZDfsIARuvQxWqdWYnX/CIY+umHX+qzY7kpwMY1in?=
 =?us-ascii?Q?ueGorYi8FUAXhomg+CZ3h2cjjJtO9L22hV2AtOuZhavDT5aLbhHyPTrw5HfC?=
 =?us-ascii?Q?MZcWyTa7nz6ejT74oynpUOZ0hkE0w/aGTAuwmro8M5w/bT5fPIM66cTsUwAW?=
 =?us-ascii?Q?qvGLBDXc8i1LDtviLCFt5iKlk5rBjWgOlTjFGtO4VbXdQLwL0WYzyl/jhRcA?=
 =?us-ascii?Q?34Dfg94YUM+SQ8ZWufwDHDUzYRYEJEfqJH20Jur9cr2wb9lrDpCaD4QpElXN?=
 =?us-ascii?Q?+Ci9F5Ad1/iGoOdDOaqGq0c7d5CKSDAZbY6Fy20wJhfdpvzw1joN4Rw3Eaka?=
 =?us-ascii?Q?wakQNkbLzxkbjJ0nppWMUlILIvtF1H73usgV89u0PJZSqvkKJZHR558uuRi1?=
 =?us-ascii?Q?Z/J5GTr/OmSzJaOgN5bOIRY/9ZNqvPa2hRUigPdwS+QMZ+zeKR6q7owcinYu?=
 =?us-ascii?Q?MCvJC9Y6OFJBkZ+uDWkFhNXHBWDeKrAlQzrOww2sJ4TrPd6aAZQ+8m45INJh?=
 =?us-ascii?Q?llO4yvqwNpyZlcAZwYXi8lDVivk3zDPZKtLFUXKWHNdV0CjFs6LCbnL3/5sK?=
 =?us-ascii?Q?wJnCpuv6dk+CNbG4An3DAEX60009UnFxtFN72Esy3lSrmhb6UzN66AlXZyFE?=
 =?us-ascii?Q?R+0oagF8BQiddZdSk7fxQ0W7h5EJv7dKRXPQ41R+mSr6PgOQP6wbSVVhip+c?=
 =?us-ascii?Q?Y4M74LhaZeKZSpPJRKPB3rxi+uqvEPzmuznaZ598lFgUnqhOxV8NjKfKSBB1?=
 =?us-ascii?Q?ZdDDjY92gbn1TXUuSuephnESfCUDOHjMK1GrNWYI+l99Y5aRzP82Db+PnEhp?=
 =?us-ascii?Q?u9TCdoD8Cfy81MqzF4t6BCDz8btZvdGR1W3pJ18XYd39hDSE1NpnZigPVyXR?=
 =?us-ascii?Q?KHHSyGdeq5H8fehcXjXL/jLRL+H2ykuovruCu+tznGbEPJUezdVLYpriNtmm?=
 =?us-ascii?Q?Fy6igD595mttjHfuWJPgq603R7X0/sDAE9rcsYuo4BJuh/iVnAWvSKBRGPij?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mYKx3foyaAz79BLL2F4oDQfGS5/QgX8y29ypU9BOFOi0fHw+wL9Zp/zS7QBukFBLN2oqqq6OqbPjm3qvdPnhefy4qHgKzYn/5XJ9ozA8byfH8Y+C7jwK7t//Azo8mGp5M4/U1DB6898vwWHX5/Mf5GwmsF9fz+1ns9j0xpH+k6wi1J403Yoxf8fJNrFjsWJce2nnLmXsqGIt2ozcfWV3z8avNEicOKPrlwFOj08cETyPA68hmAggAAKiJsW4OJ4F5zNOnUiASQHIJ7HsKHzYTfVmPDNtWXc16ScfVbzoPBfYXmMIF6IiZN3citKfaSCokeowz2pjORHYjZdRkx4FtF2nYeWgiBhD8cfJUBqmnTRcWSwKoZIakzDnr6fDT26GoO0mQqGdvNt1y0jmH2KtihbD+ZaUxpT2JKRZHzb3Ss0oUCo/+UnMgXrrcUw3OvooxSimtO+dfJxnSRlBk2FObOGklpdHzAYG+kS1to51gX/lFbZxs0F6B5/9WeqKHodmgLbJgapYvYdlqBPiyQ01y8YUYo6K4lXsRa+yRNk6XV3Dnkl+VqZwCN6H+qs50j4CHm45o8awkVoWgDaVBwwHZfFMyzt5PHC8SfWIpcHkzkU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfb646f-e083-4f56-bf34-08dc7bce5616
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 08:48:51.8882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKvyXh7i3PYOeVE5yW8EtBzj+YSfzCzdnfhFV+xeUoSXFHrWL0Pj3t3Iq2y8kV3/qUQ5/8MJAyMlSgGWZ04SeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405240060
X-Proofpoint-ORIG-GUID: O2EGZ7Lexlti0DAPBdicZQ3bsMv2xFVF
X-Proofpoint-GUID: O2EGZ7Lexlti0DAPBdicZQ3bsMv2xFVF

When calling scsi_alloc_sdev() -> blk_mq_alloc_queue(), we don't pass
the sdev as the queuedata, but rather manually set it afterwards. Just
pass to blk_mq_alloc_queue() to have automatically set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 463ce6e23dc6..ec54d58fb6c0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -334,7 +334,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->sg_reserved_size = INT_MAX;
 
 	scsi_init_limits(shost, &lim);
-	q = blk_mq_alloc_queue(&sdev->host->tag_set, &lim, NULL);
+	q = blk_mq_alloc_queue(&sdev->host->tag_set, &lim, sdev);
 	if (IS_ERR(q)) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
@@ -344,7 +344,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	}
 	kref_get(&sdev->host->tagset_refcnt);
 	sdev->request_queue = q;
-	q->queuedata = sdev;
 
 	depth = sdev->host->cmd_per_lun ?: 1;
 
-- 
2.31.1

