Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343281799B;
	Wed, 10 Jul 2024 03:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720583300; cv=fail; b=tss8Djw+v+dpChOySVS8DLEJI0qU2mGDo/PGU88HLbRx5c1e3d0MBFJ7WUSzO94XxD4kY1ihAxP3HjZMKSv71f+t8NTNWVzqd+TNYKTV7GjNenyj5W7nfueYSIEjQwyv10f7jMVfppWS/eYVvlh5QiQA1srw0KhANgSWxGmgZ4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720583300; c=relaxed/simple;
	bh=qAEcEmwzf5XfWgObBFhHmNe7eSV4RHMWYAuTYrMvAic=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qKd76qoNCWKo6uAbw3b9t1bsqkALJNxUACnCwHUbr19lg1ELQjEdISupjNMVQf5QGRk3iG00XiNv9h/TGqRIxJEyArzwR4msAUZdOJe1b4+xE2U2jzg8ncp9CbWZTsT9giR8fOwjPDwrP0NLDE4FcGOjWvutUSqwCmnCs35eRrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D55zwPW9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HPZo7/0W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D55zwPW9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HPZo7/0W"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469KtVQb000805;
	Wed, 10 Jul 2024 03:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Ln/GOybUujR0v+
	ljRqpXUcwdTHg8BUimnsRQMkhVDJc=; b=D55zwPW9CJjXUqlYZWJIGPREiD7j3y
	4RRgNKL+0AoL83aIJ4O4TkmPxjYJgw/w/HIXddJhHZUN4ndtpujCqKNUTRwKBGE8
	XiQwVjK7SgS8/L1mhYBkHJhCvdJS76+Sb8tEb/n+FszSg39FTf52lyYxO7UTeJTX
	k8v1xp6tH0MhXzKzrVJZraPUffwXIY+iXSu+84e8ouuTIWgvqT9Nk+PGAykYaJWX
	1IpD4yMVyZcQORUxpSoZUCvlzcRJwmbb5ff7m7D2gsDXn5Y7kq5yiSbG58Cugsz7
	px48ZJQRxURThlzm/TnUCQQHL+9xRKF14RoY7nqddX5U/pDl4C1d6H0w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406xfspcc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 03:48:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46A0lnn5005952;
	Wed, 10 Jul 2024 03:48:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407tx3ng60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 03:48:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlzQ48n7yoBYelKSntv3IAR8cdOJxgorEXJxPiKA+VIT3arHOZOotjVt7SjtDndfyeLUqc/jKkjno3qMeo5I5vcFaBlAduWU0g/INHmcqhurebgqabLDnE84TEyMNpfI+ElKLeJ74PdopWngMmiGq6WcQZJLtf5spjcusmJSKYcaiX14SVsEbXEjjYF/6Bj32rPF84FT2nYHf5PjCr5+xOTp/pGMZb5UqdAmX+DpP3JufGdEvB5tI1liEwjOnjGENzD8uwPaZNQczDc4CLdxymrmPrg8hfsU4eOGq0NxhqBturKGFWLie6DckcowehWaPiwsbs4QNpLzjpp6fuTd8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ln/GOybUujR0v+ljRqpXUcwdTHg8BUimnsRQMkhVDJc=;
 b=c1LFY5B3WCDQBYwf5H9iJhiSlewfCaLaMW4a6ZcHyVQAoVXw4an52ubKk7aduXmzlKGI4Co01CWSNOjK2nQMcA0gJ4EQQZ0dDhzWqOh4WAXpfOQRJNCquQbAxK3LOjBNGO6OV4w08lYdSnkzMIurA7Yp32BQ2wlYMI0SDgkn9NomYMKvy1hTSbyOSrGRKDfDxTZx3rGsQQEET6PEFg9pCuHfbe2qrFmBssC0pvniVKQ49CszEYA39TM8R26gr+FR0fYRqRUpt55GjZJfS7OfEti0U3IASN1vjLMBjm1wATotI96h6B+4f9+JuPcluVBpNQ887J7IF9DY0BolPC2WhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ln/GOybUujR0v+ljRqpXUcwdTHg8BUimnsRQMkhVDJc=;
 b=HPZo7/0WuFIaBNFvpTQV6p7vRnUTnJSdD7tNP36g9HlYuU5cocUtgpq4n1L7/K+uRstrsIOW+Cmi5aJv2xMYfs4ExbZXJTdpqH6IiLQr5hgabuohM9HbTNZOPZ2q4iY3IzmwkheF2MnOtDJpU5JgH+Otw4CDmXqoSENLc9GXYMI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA3PR10MB8185.namprd10.prod.outlook.com (2603:10b6:208:509::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 03:48:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 03:48:01 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kanchan Joshi
 <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240709071604.GB18993@lst.de> (Christoph Hellwig's message of
	"Tue, 9 Jul 2024 09:16:04 +0200")
Organization: Oracle Corporation
Message-ID: <yq1h6cy3r3f.fsf@ca-mkp.ca.oracle.com>
References: <20240705083205.2111277-1-hch@lst.de>
	<yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com> <20240709071604.GB18993@lst.de>
Date: Tue, 09 Jul 2024 23:47:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA3PR10MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: 51007908-d1a8-43df-3911-08dca093187d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2G+RVV5s72OL5Bfq/BmeSE7o/T4Kmtqon2evgGaKvNzw1HzY2Bbuu8BFPbea?=
 =?us-ascii?Q?mP/4Hggertqtnaq0kX7U/9xkbhZUVvzDXwWOTbPhQ1WfhA6SOGHc9dYaBTHC?=
 =?us-ascii?Q?IqIDNhPYQ6afQ9w+kL0k4mNyZasK9O0VrNqODPAsWVBUMt12X+8s8yTzjrWa?=
 =?us-ascii?Q?Dvtie8KKkH5ZAQK40e1klMFjuZqrgPThgsqXrki5ord7EEV8j38XaavXQJn2?=
 =?us-ascii?Q?8kunY8gf2vneDwd263GQe2dz7dVYqoqsDzgOTc/sg3HPKjzcwnuVXIyx4RQK?=
 =?us-ascii?Q?SpYGYljA1U89uISivkRPOsS2DxlXNfp2fvAAIi0q/OAjPSXhgRlz5n+iWqVy?=
 =?us-ascii?Q?TcJWmCtAg+EmSztnMc3KXxcRFrkZCJvFCotFHEwPtPmWeC1gHqY6pOOKOUi4?=
 =?us-ascii?Q?s6c4yl34sATELsjb+PyYo7nBNQAQOoG+dFjv8ICSXwkFv7bB46fZPMN2OT4w?=
 =?us-ascii?Q?CD24bIKHwyzNeYlnZt7ySSzP20dHuCQqU4Jp5kdYHAza9HpeIFR8ReOTe/hO?=
 =?us-ascii?Q?3zetsyJx+7SnxO+ZOLEwe4k1Sx0wpCN7x63gCCqu0jelfK5QTSHmlyH4nCct?=
 =?us-ascii?Q?+wvdtwezFTapHLRJPLwElqreFy10DIDAYaigOTojoLzw5uWBcpxAwcsHVvIb?=
 =?us-ascii?Q?dGvWOrg/eeHoXBpbkgY3NsGGYbrfawZg1dbpu8ISRZkmQknyNa2aYqVHAPhV?=
 =?us-ascii?Q?+qU9kkZ3KaJ3dhnKi0intWz02kTFynzAighzgJwpLE/JAz9Uzyb84/sqPrL5?=
 =?us-ascii?Q?AVy9jmHY3L7vnkL+gHRHA5+1ffcTFhCq5kitI3ZJZhfpEL5v1hE8PDERHq9M?=
 =?us-ascii?Q?qE3B+rZ6lKcZRJKx2aGMdKwEncmUo1Xh5Tom3pWKsYP+aisK4E6m/NFd2w7a?=
 =?us-ascii?Q?tejMjhaF5x3KcBdtFquCXX4jMTPe0PlaeKzNIjDW9mUSobXq3NTEmfpyT+qX?=
 =?us-ascii?Q?y607ph747xO4smglyw5Ghd/Y7LrK3aSaYZl6yqUwkmOtnr8Fg0519157DZFM?=
 =?us-ascii?Q?xAqZd1xrBDzexA9b4LJxmLdCwFOeeF5rsyIs6SOEyL9ZhhThN2Xj9XQfj/Ci?=
 =?us-ascii?Q?/zmtygWmUA5RDdT0yjbQXZagrPI7+lQF+zsdvHu1GOkMh9bWDcj1b848X73p?=
 =?us-ascii?Q?OxL6VcgxDPmMXfnbtffRve6Gy7M0vgUo4zs/6/vLEyuYJxPd/PG8glff+oVZ?=
 =?us-ascii?Q?we2KN6HslyMoEmLnKdM6xTwtYLyAJvoqSN0n4QA+8vpK/J/f3AxCGI6W2DQv?=
 =?us-ascii?Q?0TGDcL6X2C6DmqMcKiyAIxFEWtXsw9ASEF0kkAzHCIxlE2tPZB6WEKt6/B0F?=
 =?us-ascii?Q?XU3Fp+UL6QQHd54/U5wmM6N3rLw2ws1y9/0OIyizWHnG3w=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VbzcGTVlMR2e5QSy88hNGYzrvOxliciGeP7OgN5+gBPiaRJ2LYwluP/SJ5GU?=
 =?us-ascii?Q?G2VOiiaXlSXAjzQYW2DaBd1fEogg/pPihVa0cyaNpjzImDkQn28jYvSqn8kO?=
 =?us-ascii?Q?ngIqLa4G9L2b1AwJe/ckZjNc/hZUBUSWXhTCRbn8arb2/rvyTtvnIViW6TNK?=
 =?us-ascii?Q?j5qdB2abZilng8o/hNujrJ90etV3BTYSWg2J5g/Au6KNVApdvwkCd76Zs1ZN?=
 =?us-ascii?Q?TZUIG2zu526wwq7j2nyIar4JeduHtsLN2hm5AJXAa9YnPg+JH54uyMgJr4Su?=
 =?us-ascii?Q?O6syouEBUNX+I7NbgTwevDk3aJUtT/oxxJ/yPne3mGi1bFrQD+kHg6hsBYep?=
 =?us-ascii?Q?fE3qs+Im78eeYvHBLRZFJQPVxrTgLwQhu8lInM8q60U9jxabODNzPnlhdK2j?=
 =?us-ascii?Q?Gm2BgRmx3DKNBMqorP0VSArKQfmBA6Y7+Cv+e7XQrrgjLw6gCSZNVMwnwSFr?=
 =?us-ascii?Q?hEbAsJVx/lcEeh30vaPj06WuLg0tjm/NxC8NfN9X0ctdWPlv5xGqv4e3hkl1?=
 =?us-ascii?Q?21uWllZKvZT2WtKjvGAVI4Gr5eOL7aX08+nMlcrLJbqXj4o5rhSjM0RGyZn4?=
 =?us-ascii?Q?TxlgawSFcrRnbnL5fjaAq/MxbIVzzGdGzjLikOyBlwxCQzRu3A0cVbzTAk74?=
 =?us-ascii?Q?XhykWTmyEtGKi/ZfDz/MirdLXu1/rOBYDH6d1knksSywIUDgfs01vevzDWes?=
 =?us-ascii?Q?HW1cFv8IXe5URwvxJ5QTG8aUmfkHE8Zb4hPEjtyPKg03cNZqkyfoLv6UakNO?=
 =?us-ascii?Q?nVQqqmA2ChseoCR1yKFLR0rVP0CwjwkcM/qydt6riEdqMpWUJHGRdWB7ZHsN?=
 =?us-ascii?Q?GKnDqeQ4u/hxi0CWA1z7WmCt6t6hi+YYaXRqsvA9AqHRtFsCLEGO/4L9UxU0?=
 =?us-ascii?Q?5Aqzb4TnGKHXSWarRYOvV9jkn1y2IRaI/N4pAG6Jmfa0N1MbTniSiPJ6A7C4?=
 =?us-ascii?Q?euMtLLKk+tvTHvjcWlcNH97Ou/1TcvpUGvqsrgYJsxubH5H4U0K9/NAa48fG?=
 =?us-ascii?Q?5xZLIPOKEyGRTnoR6sT+mMkkzH/BpRfoX7ZuC3M7NNf9LbfKlRL+qGKHyE/6?=
 =?us-ascii?Q?eQDUxRvXnH4W6ZyCRA7lxQbnekcm7Lm0Tbd4ii+ZsUElCRefhw8O/KRy7zuk?=
 =?us-ascii?Q?op+6de9WvHLa66opcZuuvxbYxEAmmKj7ve1MWO9DNkPbG04DIOVVC8fpK6qD?=
 =?us-ascii?Q?P50C8ErNWzu6lACVmsq5ybOlHgQZltq7YSZEMH0GyKQOTVJ8BEOc6hKJXkhJ?=
 =?us-ascii?Q?RB6lNQIUoVUEFeL7b0o5pmRhWpdT+TswRg3M+YtURPP5uxSYx1BYxrDkH4Bv?=
 =?us-ascii?Q?ae1Vqr2bViAtJSWAgjVfDvWKsb4D0vbAmDER+KQuLb2x6U0VVnM0tZh4MhjO?=
 =?us-ascii?Q?8JoigkxvWF7YWHj1zQosXTr+5Y6Ug4PWQXNyMw+XxH4Czrftr7goZQUXPfbm?=
 =?us-ascii?Q?ad6e1MX4vdFN7UxdsZdb4bRqKVRLCfhV17QbPwhdZasxXs5IJ/HH9/+jrvSh?=
 =?us-ascii?Q?Z3Tspa0RnoqbjExVtMDAdHQuyvxCXl76kfbolpTnfj6uAy8O6aQ+e17B5r9o?=
 =?us-ascii?Q?YIGsvevmTnL0lVBJTEzqiOnYTwEd+JSS5PXREOofIFktCTQYYpQEoy3u/ZHv?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QRkD+h5zZUmLglAjkw2tZovUQh+MUYqEZtaE9X5DcQHCySNWXfsxVup9RN8A2O1+to5JFQq+uLE3sF0HuHr03KG4FzFLC1ofdqHfetCYpUjpT0XVFvY7NqN4GSMBKeCXj/o23upXDTakugRtodoUuM0e3byGvZIpCDCxtRs7PG7UL0cGUSUNRLIjkMSscKd09t6cEDR7nAZgP2FwxeOqrGzAFYBtRSxrU+ua4DhgwshYFv/hbGv4se2IcBSTIaWiJVgo3hRFUsH/ISrtUK8TCH/rDv8ubzcT3Xs2DxuQTxLiHzbK32IjfWsws7RBO6a9YDLtuJsE6+gBNpzwk2id8n6YpD5e6T+VaqhC/v5kuXnSy1hmG4OaQKPUiR4gR102BhGtc3+Xl75+oPWJjv8txjN0NmzAE4RFbbzZgNUllToUAp8mo6gXsLtB1v7BF5LTSd2YyboiKrRLoWnfXAEVR39liLlIbdX2NBn6tqH7V6/QchGASkCdIVhFZFWRopTipdwIPGRykjfHoZDvcXXpy09+ZPawNlQw7FNDEV92FSR1XyLpWbG9xsWgf3r9Qcv/5kt1jsDGsQTezGHb19GR4lqKtTuh0P108mMKU/fd4Cw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51007908-d1a8-43df-3911-08dca093187d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 03:48:01.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Me4I8WT7b28OlpFNuLuejpwi57xWd3VxXuVVf2xbeljPnB5SJ7+Bd2dl+sdGoJNDudtrnANqNx0cL+x2EZXnUk0XC6mIPx9xy1mAf1u3/Yc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_12,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100028
X-Proofpoint-ORIG-GUID: p6qLDCb56xeCTsqVsRDMJnauRgqzqA52
X-Proofpoint-GUID: p6qLDCb56xeCTsqVsRDMJnauRgqzqA52


Christoph,

> So what are useful APIs we can/should expose?.
>
> If we want full portability we can't support all the individual
> checks, because the disk will check it for SCSI even if we don't do
> the extra checks in the controller. We could still expose the invidual
> flags, but reuse the combinations SCSI doesn't support on SCSI,
> although that would lead to surprises if people write their software
> and test on NVMe and then move to SCSI. Could we just expose the valid
> SCSI combinations if people are find with that for now?

I didn't have any actual use for check-this-but-not-that. The rationale
behind having explicit checking flags was my dislike for the fact that
the policy decision about what to check was residing inside the disk
drive and depended on how it was formatted, which flags were wired up in
the EI VPD, etc. I preferred an approach where the OS tells the hardware
exactly what to do.

There are a couple of free bits in *PROTECT so we could conceivably work
with T10 to add the missing pieces. But it would have a pretty long
turnaround, of course, and wouldn't address existing devices.

Also, things are not entirely symmetric wrt. *PROTECT for reads and
writes either. I'll try to wrap my head around it tomorrow.

For the user API I think it would be most sensible to have CHECK_GUARD,
CHECK_APP, CHECK_REF to cover the common DIX/NVMe case.

And then we could have NO_CHECK_DISK and IP_CHECKSUM_CONVERSION to
handle the peculiar SCSI corner cases and document that these are
experimental flags to be used for test purposes only. Not particularly
elegant but I don't have a better idea. Especially since things are
inherently asymmetric with controller-to-target communication being
protected even if you don't attach PI to the bio.

I.e. I think the CHECK_{GUARD,APP,REF} flags should describe how a
DIX or NVMe controller should check the attached bip payload. And
nothing else.

The controller-to-target PI handling is orthogonal and refers to what
happens in the second protection envelope, i.e. the communication
between a DIX controller and a target. This may or may not be the same
PI as in the bip payload. Therefore I think these flags should be
separate.

I'll mull over it a bit more and revisit all the SCSI wrinkles.

> I'm not currently seeing warnings on SCSI, but that's because my only
> PI testing is scsi_debug which starts out with deallocated blocks.

SCSI says that deallocated blocks have 0xFFFF in the app tag and thus
checking should be disabled on read. And if you subsequently write a
block without providing PI, the drive generates a valid guard and ref
tag (for Type 1). So there should never be a situation where reading a
block returns a PI error unless the block is corrupted. Either the app
tag escape is present or the PI is valid.

SCSI subsequently added some blurriness to permit deviations from this
principle. But the original PI design explicitly ensured that PI was
never accidentally invalid and reads would never fail. Even if you wrote
the drive on a system that didn't know about PI things would be OK. This
was deliberately done so reading partition tables, etc. wouldn't fail.
In Linux we currently treat Type 2 as Type 1 for pretty much the same
reason: To ensure that the ref tag is always well-defined. I.e. it
contains the lower 32 bits of the LBA.

The intent when we defined E2EDP in NVMe was to match this never-fail
SCSI behavior. So I'm puzzled as to why you see errors.

I'll try to connect my NVMe test box tomorrow. It's been offline after a
rack move. Would like to understand what's going on. Are we not setting
ILBRT/EILBRT appropriately?

-- 
Martin K. Petersen	Oracle Linux Engineering
