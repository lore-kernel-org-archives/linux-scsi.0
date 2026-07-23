Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29291438FF7;
	Thu, 23 Jul 2026 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799505; cv=fail; b=HhfyBXpWmxDbin9nG8x0T3HHNBnqT3uCAmT/FN6m1GhtU1IXzF9HY5qdQJeLu0zLyLVNrwrD0utI/sLM+dhtCwYa0T0wVLTaRxYOS4F7+7vqBQGyOdWVJQ6VeV/xGC9rSGkA58Pj5P/Uzp7778MmnF+inV99SVIT6NtuS9K46l0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799505; c=relaxed/simple;
	bh=4UcIMKzoSiKydCvcoegV25e5TWW6k97Pv+cl1HjhZyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hc8Zp+XvY1Sxx8WK8x+53jQSWNhoF3/lTBp1pSJtUQ21yhNjcfoVdtVYVIvSe51wT3HPCrIC7tkaUI2cKtyt/rO1FA06r7mY1d6THEW4Qq9tO4ycg3KbSJ55SpASP026+HGOaooWzmHUSwSOEWZ7rI1OpcIYOwYxutNumWtCSwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gitJ8Jd/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vzu4bvEc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gitJ8Jd/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vzu4bvEc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJthu23404240;
	Thu, 23 Jul 2026 09:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l/lSbDlcxAFUzY+hpvDUTg4m9EHFPM2Y8ZWz+Tp5GFY=; b=
	gitJ8Jd/qlgn5XtdCG2s5JcJ+hHPhl1VXEvMXjQ1eNzz6cf7dUT4WS6cfcDVCxpP
	8EBjBUl54BvlZwxUPVF0xRo46Ph7h4PEuCVrB5S7ztlQ/gRs3wDFydzrPIVfG/xG
	5yEsufLzaFyPvcQeviKe/pItrN9TIPmy+9n9QSSIlsokX43d1C9dN+Ys+FYOnPD4
	Bzkqb/yryWKbainVhmbu+tmfNQR/zJcQMoQQY8qk6QWrJzBi1nkHTM8GFPraXz5C
	GGDNJAAPYt3xUTLyDEsJJW6/pyNZ0YNzlLYkWcIoLx995eb4t7mpBqPztgK/BYBF
	uZ6fCN5lHXTszAWYAwLjvQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3pmqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9NXhb008288;
	Thu, 23 Jul 2026 09:37:33 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxrwn35-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bjn+v7wkYbUbezBC20waHvsLK4EumMbsRSXjMiAvw9Q8kncwdXCPxbS/+K+yg0tsIUjqsFGRLvU0OujU29Jxw93eBi8NqrhRtqGQyGXYu7tbqpKtILSrVEXSBpZKjbc4j0Ny7znGZADzPWGzA3+j5jwgcHt0OpfpHQixU7t53SEo8ATfDaeSsZPJQNrmrYPeE7uNN/17wIPvYqcchFJATc5YasHTjBT4EMEIWx/MNyWpeRyWKcJYZDhRdOrNyJJqMhxILPlQsmKjf4ptlPxOru89r3qjso48kN7uTce7CHed/vNPcIDkFGtK1rHSBWUvmcT3AtaDpDTre6YU8DM5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/lSbDlcxAFUzY+hpvDUTg4m9EHFPM2Y8ZWz+Tp5GFY=;
 b=uOJnAtxu5tLudX8S/rE+ErgiGkKmB4FaC4qUOZr9fwpqHfgotfkfq74MtIO0Wh11k3EL7cFoKei3RctMossqdIa1fAMqFDo62pPmX03X2oq17C7Pze17GiH1wckPV2pv4ouhodPnF62+0udgVbQBholQvkBru1zVrzhXgSWIT/nXr6hGHRr4aAwf7rLhD5gnO3EMJ0mGA9/5rGwnrrjUaykectwNBN1mYZxfkB3EM4DVbNa0nreCM45Qs30oPwuS5WebGKBLz7Z6Lsg0mrmNY13bP0aKbz8EInYKvrPw5R3uLFD5gUojOsMcbjUjtoF26Prg8BPB0Rn6pAIWP9RnYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/lSbDlcxAFUzY+hpvDUTg4m9EHFPM2Y8ZWz+Tp5GFY=;
 b=vzu4bvEcZXV3/mj6xA84n55j8Mve5EYVmexyMWBLjkmeVYPtsTJwVQX9WuLTWidKxSP5O5OcPuwEKibGAja97K23mqsQBOFm/R7BQZDkE/2Ux9FDviqbKXNQkJba64cx6Cw95gAesJI2L7LEBMDNxHJUjdpmQHu8RgBEC4e/zFw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:37:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 28/28] scsi: sd: add mpath_queue_depth dev attribute
Date: Thu, 23 Jul 2026 09:36:26 +0000
Message-ID: <20260723093627.2327456-29-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: 98b2cb56-6c00-44f3-c71b-08dee89e03e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	O+p5ZjWZNyRaMw/ras071KEVFISXOISmc4qTUvqeKgV8eUPzz9PuO0GmhKypLIULH0DILZJOPZm7jblhHkkP48NgyFy+sLaC50vS0Qvhx7m71Esijc7QaqRWdwI/cqqHVXCaOJWcJZ/CQ1JX0WiF2sxrS/hxzUj9hjEbKnA6t2oZXmA8Rdr98veHJiCmmSPLMAGGP4+Lk1gtkYG7JAhVKptK5a1D6ik5rD9tYJ3V568eHrjY5qi8UeQZO7Mgg/k/cXihU8I68suhA6wyyscGSMQXLuzgmEPAPxRItFFZ5MGl0S1YXiHibkHNu6/JWLPHUByJs4Ey/Wkauog/2a59pkyeJZ1jnTuy9RFnQ4C0r4VVbwFhbtDpNsVkpXxsjipMfXm+CGgifErUrgKuehzB+KoDXeUbGq11AWTpGnvfBHoWf6bUSo19l9mKCcNcPwSwgUl3cNUque94xQ4f3qck4lH9rUEGWYnnzPMDyICkUYmW4j6oAUtdxlJ+fPmejrnqq6tbegm3mtlSlPBGicwZ9/fcy5S56W8S7iAIy8jvgQwTY/iHGn/RfpYlzmOQdSu3gef6lHJZ4291BCu2WOgoBUEyGSc8/jjZW0fsSHn87kbHxAUNdTEqJEwV4nga8htglkHziwiHahjHXC+f3bC8r1PVJrieX5LiJkhMfmbDHuU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T1ekrMG4iqrr847NVjtiRN195uY3t7ZWbDdA8jyeyqeB8j5qM25BIiAmUmCa?=
 =?us-ascii?Q?y2MFuQOjwDoCHAe8CxLj37vnhLFnej4nLxlLaf0d3hEtmpwIZTdhDBd31UFQ?=
 =?us-ascii?Q?pceg3CDzJ0039z7teHMR8Wukq5j6o+ERxg8HQ1GJWCjpQYIOK4j0gw8KUk+6?=
 =?us-ascii?Q?tXPwss8l3XEqAQClwlVXRZ5NSkbr39BqR4iFDCg6DxcCTpTLnf8ItBL4FDFI?=
 =?us-ascii?Q?xt0NVFclx8JUAU1/FeDqMomaE4IlRTM5xNGVq6M772rnbd/qV54Yku5jOOxe?=
 =?us-ascii?Q?UAW9y3z/WUF1ZizWbEOvMmhIcjT24S/fD+Lp3KfhQWhlMyX5ObjOSK3zJLKn?=
 =?us-ascii?Q?j0xkMxvG3UzSvv28ERtv+8KnXhYP0xhIztwrbtg4MTWR5ZZ/CGwpeGvsdvHH?=
 =?us-ascii?Q?eXx9MjfwnigmLOnuHHRmVjGlVFk/3OMlC2fI81lqZWSYqaaFXVsSMjfjmiBE?=
 =?us-ascii?Q?OWPdi9N7g0mbaFnXChz9VPZ2Prm6gOQFaeLZXvhmBXFui4t8lZPSRNqFYtbr?=
 =?us-ascii?Q?UPb8yaEuq4L8dAqedmQpleDSFbZSVHCAlAyLmNxmpdGde+HUu96VSqXEkzSV?=
 =?us-ascii?Q?yE5/gNOFSXyqjxlWgO796rhp/TISNh+FjygiBF3RRHQ6KcoOy29aClEGJO9i?=
 =?us-ascii?Q?0t6BKMcj305KxhwQXQs3TQV6hQESyJC36tQT2yG7u1MAP/DzTIL1n5cv2tNB?=
 =?us-ascii?Q?kkKI0XG9v91c+yAP/+QngIxt8a0MTJlUrle3PwSEakqYZdpssLsGlF1ceyOj?=
 =?us-ascii?Q?NiN8qQinztQALpSF2tVqCGB5eXgNf2NB0E2Q8K44AKlBrCT0kZEwEPzrkIVE?=
 =?us-ascii?Q?GgzmkugCTqDWHjE7HitfwtebikltpH7WC649bkjD1lF4cdZCCNcJU6NGEpqR?=
 =?us-ascii?Q?nq6Sxgb0XVik9EGcqJ7qTSEjRxN/j3VFHtfPqmBYPkKZpIf6n0qTvgj4yx3W?=
 =?us-ascii?Q?iVAp52lh3FZLozllrhIYCzIPeCbZ9qXnWAgrfy37YTlRRR8SSlI84xahAaP2?=
 =?us-ascii?Q?Q1A35jfJeiroKiewxG10CaYvgQQmYIhtoDkDFw5kQ82Z4beAcP2UHu9ecX66?=
 =?us-ascii?Q?91753yNp8T/4bOvsX9f7rv1NjuMnGezYSnq/anu2ZGTxmK+iYWnSRQRaghD9?=
 =?us-ascii?Q?J//KDWmfCg4nXWAQ8ThqgU8VvGpE62WvuNS7oeem4Cs8Uw9ZNSjnFdkQsbLQ?=
 =?us-ascii?Q?/S+b7E50spolMr0yYEvlnubery06QFnr8HQc6A/aGeB37dQ93h3kxzBOCyf8?=
 =?us-ascii?Q?MKbxB2Pl33a4n2KNfhX8RNcFhiXBeSbli8PVhRxikI2Oq6RJyGvfs1t8xMDr?=
 =?us-ascii?Q?F0p5rixSOvs7puv12aN2AkKMR4eBOXReWaaPEqJ9BW6mH6CurIWSbSaJ8vw4?=
 =?us-ascii?Q?UyO46sdKgqqb0alZbNgA/ADUC7rZCk/KlND3Hsd1QSy25/+nb1CngxyEk9dg?=
 =?us-ascii?Q?eOzo6ajIIXE0KPNjLJfNgLrLgfoGpNuV41imTvsNEQUwi2J17aKJjp7PMEI5?=
 =?us-ascii?Q?Y5GxgW1QnDsgoDf0lzjOoHY2At/ltPu2wZGz76sdyWVgupjU6YKMAI3r4d1s?=
 =?us-ascii?Q?XfMYGfPMumVKVYqka76pcN2G67kS7DKx0+ylc1y7eOLfNbTTZKzBMTSXktKN?=
 =?us-ascii?Q?iByqenQQGAKMeOASbuqec53DhO9x94FXqaczW5FQkrFHpYyYshFsLTQFVetY?=
 =?us-ascii?Q?twkhjdLUQbpPiJy6OFRCxP97pzVkiRt9bThcdoLBSuSzuKlLbjIomsITM7G0?=
 =?us-ascii?Q?SuX9/Hpryqd8FKdLxvr8utYeh+co8Eo=3D?=
X-Exchange-RoutingPolicyChecked:
	T3BmXpHdBICDpHEvKeEJM1FaZMNUQsoDdWcva4MHzweahzk0rukaUt440MzuydWwfYZTP8sDPOfqK1ZMyAbJdwP5DnyLJ9DAhZKBPWcJHrQgYviEZqsSOZRW+Nrk0IUQ0LF4PaZWzLH0k+01nhtpNCcCUtn3SIURNzTxsZgcLkXHVUl8RgY3LHRt2/gYCvveyRcD+XMdesYjz9hncQaSTk6XHad0/CnhCPcAHheTN/L2BgCFmywVxpEVQYVF3jD3Gn268ROZc11fXT7DRmI/fc0iwmg/rmXsSYYBgBMF9zcThCeAJfLDBZHUi/Nte2IjGvyplI2gNZPpoQryPvR+jQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kspHtlCoF1FkjlR6Ag5wFjM4Kt0c/7HALUkOfUMcWobz6fQAHQ2C4Z/b0rcDCyBYnE00pwaFixwwdRrMEPcuJjxUCFBC2/I2AXd0ZOfZV810gKGbL0/UwsiJF3MTWYaacl1cUV8zlfhpO8CEuJ8h/glnvk3khNFGH2GD5LgUhRIb/C2yd7yGxNgPGWwSIlCLhQgXCQ3z+LNxWgwu3vF0CDKNwkpNDEfTC3x6cSY27PSMGluzKndvoVxWC31cnUzVpL3uI3IGgLn5yPt727xyIFK5GFO54M14A+UUO5Lu4P1ScSHwMdzu94xGNPZIFcJWcnosU7OKes0XY8YY6EqnYdEeUjGHxMJTP7sCe6mWVUI8PBhlRZbEDYbHuUwSEGg5YQM0wVleVPpMoFWdf7FUlzYFRAE6sxcRLe5GyNKTs4JnHxgqQrxHXbWM2BAjR/+ok0PHz177g0pItjMTsXEk3/4JDB8vTCKvBiiUUKbXkiPZwQ7whiVJ0hJck33ySKhrsNUCN+Z6YaprrTSJ45TVpWCSVBL5n+ZGA/BuuysJPc4y7jUYmuBH60L+CbvfOknIgqP1N0Cefxi9nUnaFy1J0YfHSBop9x5xEdBb4i/wNmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b2cb56-6c00-44f3-c71b-08dee89e03e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:30.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KeZPFvWCRxKha7xhr6qmP1epT9hro4X3SlHQq6+QLmXQQ0/BPbqQ84zKVuEPXd4SCPBNCeZ5eo6tm3yGTE8lRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230093
X-Proofpoint-GUID: 5cWDQgq1xsJCaVRIxiVpSeA5oz6pzFwu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX6YgbOdNQiOWt
 bf7xSH8w8x5QYGXWL+lOzoipZ5380/NWyja1dtqUZCpenh1ISLT+JkAqyu4q4tsQUhkR2c6aogk
 wMKyL3U8tk6nTJYareW9yj6KGDt/JL6wpOfJQYWFmsysK064p2tB
X-Proofpoint-ORIG-GUID: 5cWDQgq1xsJCaVRIxiVpSeA5oz6pzFwu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXzKkWDQUKovew
 oCFnNLqyKlD43o5CqqlC515dKfvNHjsMaddlLEGbdDSVJwfhwwuzsWhOkgE+T8t1iFTM/agC1mt
 /eYelN4ZWKc8vgmODgwflJypmrCQwTQvx4QNeK2XUJw0RfkRlIDAuWqCjJxhVeoW9Zh9MhK/kvS
 UY7w7O/t4kPmbzTKMnpMc3RVVNZdygsM6QNTKoGAcf41r92kjcFWZJWY/FIVFAbTWwniA5b/8W7
 i6ieh2mxjP+7tG9KvQW/PfXNG+7xyqEAcZFGqI1VuVnai9bW6lYZ5bDDTwyjvlRStGlpKqb5XTr
 ++HejBrOzfNeTXQQvthj5iLhJmDLkTmjs6klpXNFfJCEIy/JD/deszsgL5NUiSqD912g4bsIaRJ
 2pSES+k2CDw6pmXwNEkNRR1LrkIimMoDuBGPDJk30/prMAQhwftIB/SvrqhmzaVqq1lf78/45r6
 jAosEj8ZoswJXJH5ImRf197Szi2a7YJyLi2rRHIw=
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61e0dd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=bA5FzAUjrTEoIiOIIUIA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7255df6e3e971..7b87404b70d6f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4089,9 +4089,27 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.7

