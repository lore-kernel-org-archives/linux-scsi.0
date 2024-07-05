Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03F21A0B;
	Fri,  5 Jul 2024 03:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720150236; cv=fail; b=J63xVUB1GFgB/8k5f3ibSZrvr2xT39b1CXq4kD7fwN8IBtUYJaV/a7ToKN5ZW27JR5uLfbWr8mbFVpXWYpaqOEHvwgPIieiQPQYJSJhWMBvmcjKg0EiNhcUvBeusj6QZ0+JeNhC2VjtSO+5N3XFsF5/z/9OmzGgcpaXjJdA8Y/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720150236; c=relaxed/simple;
	bh=VhixeRy1ceFK2ykv+31stVHjb2Akj+zXo5Y9/qElI0U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jcU2+G8VLW8DWAHZMdbjPStcbVqP6hwCo7kVq7Up14EW0I2FQ/8klz3JDWDP1FJudn9Wys00MMeslvCanpoasDv14mJDgUyGgQjgNEZAqMeT6/i/nx/9Or9spRsbcp3ATww+ocZG7UgL1CE9xuJ+KiJBjHsaSBfwkpcNCSfsps0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FaVEgIPw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rqSIvimX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FaVEgIPw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rqSIvimX"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464NNSK5000691;
	Fri, 5 Jul 2024 03:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=yzYQVtPumBxDGF
	anIO/bBJpgfOljElifuUC2pcQ5vQ8=; b=FaVEgIPwH97EwvoUPcRwz8ADL1FbrV
	yi7bwpcBaNg+7U06xL40VzR8KOJq7c6N0AbRIwjZT1ZtCe+dIbQf2eqdj6RRvbn9
	Pzc0miR8tyG5mBLNDVJH5+PcxwlULobbcElyUUZWWThb1vLXq1oEHTDyjjaMmDga
	594rTz22D0nORipv1qK1KBtXTIciJEtmvscZEJKhBt1YtJoMzdVGnCnVZef9PM21
	GwEnyg06YsnjvsCKsrh/DN1ogw1JCz+bHjtk2VCDG1FJZJqMZb76IUrXp72xQWUK
	D2oPmO61ZyvLilGhHLA7P6xBqwbVwR0IQNEEFyuD+G7bhdJFoStuFrgw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402aack55j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:30:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4653B5T4023558;
	Fri, 5 Jul 2024 03:30:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 404n11vcvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:30:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiofHqDIzSw7Uq4VNTOJDpDNttrkYizpk5aoGzpTU83seqIHClvdIhU6mix+bWv9uGkev4tatQzVZ0S/AeWnOra9GHC9GD05cI1eT4D+fP/quY6OgvRJEvBeBqUeMt7YwevzTdXTGrkVcscBsmQ/6rTJ6HmKVH/wl6AW+k8lm1ZQ7YCs17UdfK6x6bBRr+a1KWOa4Oo733ZahlknM+rhhxDjoSTuUInNnNxen5mOSQ2iG98Ch8N+i1LDHO55f+9V7yluugSaJbjm+yQGLXQxEg+Fd/sc5F846D7v88bpK1wp0kb1XCNvIwPnwPsZCHuLnB54GgjwOY0m0tRTyVNX9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzYQVtPumBxDGFanIO/bBJpgfOljElifuUC2pcQ5vQ8=;
 b=m70OKSyP1Xo2D4cKQwcm9zTHPpITOm19xYwQsl5Mb8ZV+qdayCE6+r5Aa5HZ7kHWP3XODU+gXAIR4Tq2Gp1q7ylzRFsOXjHtCctB6yyjb380fXzGyR9qTHVRp+L6W9dspG0FLysqMqI1S2/8JWX23da5Fc5Wkxn9vOkO7s44Bwvzv4LSWxtYU++efbMry8K89GmZTaumzVBf2itipsQBp0B6NE3T6z5Zqv799SktbWqH5Gg37gfskcR9Mjv0tvCFpB5bV23MwpkWqIiPAR/GPIEGlO8kUWJqJgtjEtbHA7J71xYloqYNN56IqcaWRDbkZtOBGwPInEW2pCeg2FdTsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzYQVtPumBxDGFanIO/bBJpgfOljElifuUC2pcQ5vQ8=;
 b=rqSIvimXpVzDJxS2yb/TRUw0gxB7zwppQTK7+xREaIGP+zn4p23YuLxD96bgsrzbxCUA00MffrAU5rdZAjvk6mvNgmgGWLdOeIHL+uI5lHeyot227zg+s9nWO6eF+lqaWnq8k7Cuz4yQGXVFlBwFhzwldBqMlOQ+B0edRXIw0lg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4235.namprd10.prod.outlook.com (2603:10b6:5:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Fri, 5 Jul
 2024 03:30:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 03:30:21 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Mikulas
 Patocka <mpatocka@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang
 <jasowang@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] Remove zone reset all emulation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240704052816.623865-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Thu, 4 Jul 2024 14:28:11 +0900")
Organization: Oracle Corporation
Message-ID: <yq1frsoa53d.fsf@ca-mkp.ca.oracle.com>
References: <20240704052816.623865-1-dlemoal@kernel.org>
Date: Thu, 04 Jul 2024 23:30:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0137.namprd02.prod.outlook.com
 (2603:10b6:208:35::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: 466753b1-3dd3-4d01-e9d4-08dc9ca2cc71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?IgQQpPS+1bspCVh/CMawVxrX0zsbmKCfJ8Pp0aaWBkXPdVyu/PAbwZKqEbkq?=
 =?us-ascii?Q?Ca5CQ7RqeCXisMGPzhp+PWKytzvR8qbyRBGOpRTcRkgqe1/bHDqaPkgrmqL4?=
 =?us-ascii?Q?HhRxJAnInpFloQCXbe8GnLCammA96SMA7pJgz6xD2o8dEMIOgVLq7a62Djr9?=
 =?us-ascii?Q?CF1JRtfzP4kO28F0WlObpGX0wR6/6s5+8Xcq/RqWagd8zITZMUWWx90XS5q9?=
 =?us-ascii?Q?zBjk2G3l2tmj2kO343Dvb9CuP5IftNb8YRjQHLMRAaIWXDFpqETDoebQd+Qa?=
 =?us-ascii?Q?Hp6ByPoAQcoC5u5scBtFaPYgrjXPUpVfleM9LcXWLSbZPZBTdQm33qq0Vpa/?=
 =?us-ascii?Q?1IneRFYxydsynZoSRmI5T4QcXxPT0uClCPNURGtPZCrkRdB4fbQlDGCeMVYS?=
 =?us-ascii?Q?iLJudGLdQ2C5mfoUUZltShNZ4m7sSYEwsFNdCqU2QCCRhATo+OfW+fjRJDXW?=
 =?us-ascii?Q?Wt0S5emDAbwt/0ADxvb3vtVvAyNlpDLm29cwNr0QiBuJM95lphaaOyaFHty8?=
 =?us-ascii?Q?owKq6819PVIPTZHC4/QwM3eJlU6Ni0Mu7NBMYjUgjVUwvSKy1ll0ySiHREks?=
 =?us-ascii?Q?ZIjZhOH0Ake0UBCbrEZX1KbMAOmihUs0q14XuQrzlNwFWkdsRXLZ4ggVt6gx?=
 =?us-ascii?Q?1AGxFymQxQrGoojsOB2Q7Ye/WcZ7ZiDcc1eosXNOu7S1EsSdW/hiUINNzKph?=
 =?us-ascii?Q?QQAHRrlct8fwj//sWVVFS/VICZAkxQcFcOXNd/CCMq0FU1GTQU+Hdt4N7Yc3?=
 =?us-ascii?Q?AXJ/3IRjLMD0XyMA6yFcOLNp4QKGHiFov+7gOt2R7/X3u+T/pgM/LsT/Jns3?=
 =?us-ascii?Q?R6BPTfWtmmWt13fzicQc4sdo2E3cUl/S24GKyUip4v6TGUy9FhQRpHQ+cnbJ?=
 =?us-ascii?Q?kXaGBHFsiKsoBADnm+8Zcq7Ea8jwOU/f2v//ZX3LiAm07Zio7AIFVcp+FO4g?=
 =?us-ascii?Q?9oD5GldMg9R6pF1uhZpcDjL6dRC2Bv3J5ns9p0nTANDTp/8FR+LtTgzehQD1?=
 =?us-ascii?Q?RAsOwnSYp04qX5Hhbcf7ccHZ7s+wK5/bBfxflyinofHzFVYUE7y2Jee+3Iug?=
 =?us-ascii?Q?gDxTE/1r7eD4P15Pb+kLzTQwlJ8WNdjf6g9bLU4Q5XIY8+YVBwJeyUDZWpvv?=
 =?us-ascii?Q?MyURp2z8Mi2jTmTuHny5Rt/HsGZ9j6yeeLkJfKodyXZb8wBRsihWZ5tA4Dfi?=
 =?us-ascii?Q?Pe/baDnAaj2uAQ4TRq4tHTmB50PugFwClHehd+qbGBsaWHTgZ30R1fSzBIRg?=
 =?us-ascii?Q?PYsRshhmcThahucFZLxTyzVIdCbX6A3xFHeBbcFk4TdQAOQOz/AviKFlYKcC?=
 =?us-ascii?Q?7PWfaxRwb7IbZaUjsjuDxh9igcp6PNJ4UJqfU4dc9gpfmw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3G2kS/oKfOgbcQcHuhmhJpaM2ReFNbM+HiQ4JQHcKHyVfYtwSpoD1Q5joC/Y?=
 =?us-ascii?Q?6EXO5nU7Az3Ry3sHscDQCRUfirMArDvxAS8eNFoEPLoKr7s5cktfkGEjUIG/?=
 =?us-ascii?Q?1aR1j4iTac102MKESJJB6t/QZA2E+SHt9imUYH8bYIyuA3VIIOzR+jl1MHnn?=
 =?us-ascii?Q?88sVA+oBlJZASlaCjEFoX5gQ9tKs6vetlGKPjRQSbms+JSH8eDGBN5V1ot+V?=
 =?us-ascii?Q?eiF5uX1Y/7Bajidxz6OmBPVZjxuuJyipO6oVphWT1iNqjp/zYe8GXHU4dmyZ?=
 =?us-ascii?Q?gPXguEbq4Ic6bC9mWBgh4EwABlPdSPT5rH/+D9qcwbnqFGOqLwhXjoC6YF/g?=
 =?us-ascii?Q?2EJ3SdQHt9bx041PQHxfVFeDNtue2m1HjESjtkCVCwucoGQ9d1sgiWKr9ePB?=
 =?us-ascii?Q?TWGDpuSE01AN/FWbFSaEfyK3YFKg0XUM4NQpCg/LSUTyn87M1sFIDM5MUCL7?=
 =?us-ascii?Q?1E9Q1cmxM3jgZrEF8oQcUjW4uRu8gshdqmJT6WN2MinRNeQmzeO4h9deOxxj?=
 =?us-ascii?Q?jGDHpD+swpdJCU3AAz/Enpkcql46hUpEf6xEKFxpv7C0r5DhRDZfKKQkmIhN?=
 =?us-ascii?Q?4Wc1umTM0QudqlaYkNPIJW4i43f8g1sTD6QpQP7j4S3VqTf8TjODmH3Qb2V1?=
 =?us-ascii?Q?vLjc9APG0gY8O2i90CzCljSSoxwbmJ+Oax7coNijilKIdx/plCx5at3pFxi8?=
 =?us-ascii?Q?ciiv2ua48O1sEwSpzqqIGxlvWPpNuirBaFoJw9nFQOyO8dtMltLfSoX0V30Y?=
 =?us-ascii?Q?5yd8+fcEYWiCoJkeQN0HJQjsds2VipsY9tFGg+U8+0glEGSaLK8Txw3VP/Rj?=
 =?us-ascii?Q?1ZuCkST1tE19J64YH879DApKmMmxJ54dPdbFjefp+KoltGdOsAHqCvgfHCv+?=
 =?us-ascii?Q?Lu1qtDwvYvS8of4vEn1PMSGE8kBZ9Lkfzd78BQgj0hK+vLKMdprdj2tpGoQa?=
 =?us-ascii?Q?GUe4w6fXUpefOZI6EgSeFnP42rh1DH/4/O/T1Nzjm49Z4MFDGnsCwWogYf2L?=
 =?us-ascii?Q?MPfygD3zsMhRQ3c2m5RaVJCi7b9MOm+p7xbWSqOoP+mrKH63fBLPDcydV553?=
 =?us-ascii?Q?ZWSdUkdD4sJhZHtbW42P6BMN9RzBI3prPNhmL4BCpnTedUNMMc5GoiKosBax?=
 =?us-ascii?Q?vpo22IJJ6haG9mQYhh/RyTy6TgmsIH9uGHBEzJlt8tiUR7dt6Za8gB5fvNKv?=
 =?us-ascii?Q?zjY/QT9Zdskh6gQP9o/A0wlpBVaL2XB5aeFdA0kmlsL6viUoX6tBbt0Rdp0B?=
 =?us-ascii?Q?wQUimRUAAxEsZEa+JWWBPc21ObUFSGDCPwZI+NkbF/YtHG4Z3cd9r+YCbChg?=
 =?us-ascii?Q?we5SoT5DXuU3vOJpY+uVlkCKoI5ereKwpWW7P2OOB0bZHYqB6+NQbIzgJuSB?=
 =?us-ascii?Q?4NziwjgcePLyXX9MNsqiGo5xN0KAqZopRHyySaOEsBcOHIGdROLJ6SywBCxR?=
 =?us-ascii?Q?etnV3mV501mKjDnCOVQt5EpSD8OUtVSd9DiIn3PAh4/ROCFqZQ/bn8RqJzI7?=
 =?us-ascii?Q?LNnX1nbVa4o649MqBVXIFJAYqddNsg2sxNmY2MmwAi/K4GsSuihckUpaC9xC?=
 =?us-ascii?Q?+U88wFs9sVysMI5azkB7P/ho6gB0YV+4BU1Jx1awFcVA/6wjfkS0GtwzIeh0?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iblLa2LXGaBUkn1xeVXc3U55lTQLjgc9cm5ZlnjlTOD1ogB/V/AXYdnrUL+2ctroAgu8LTtbbjR4P2xG5R7zeJvQ1N7oGZg0IDgDGydo5JCOR456SUb4Nop9ZFv7+pOJxBfKmaIVlSSW3/+5tagwkC/NcD6Yf9Xy63MC7bLH8klNyzhGyrRaNcuQIhSnGAmsG8An7rgfrC2wBScQG5vjtysduvg9vaXR/zVuhLKE68O1ISAw1jLMvDmd7eA26m+j7d6vPSjK7pSxMvG9bkr1UseAhQzATHpc4xXfGGx3EGRr+8VfD3XVNpR8PL/L9f/Thp12BVFaLmj7O+eoyBK3TKmqXOerVo8vFjIVn0zqr8TuhE6l0TOcvAtVR/xrwPeyXz6N+qXBjmk+IvSaqc31I8sDPWe0f4QeWaiAvPCk/SJOuCcRQkGoyq708Hd8s48ihBbFuls7/7oNMb6XARyw0gvQ7AYLGnru3UD2crIbVsydAEXKyCtsae+89XxrbNj8c/wVjG0NCxk2PYPDcaYsAzDWuTQR5CaT/deUgHva3EXtDk4Zyo5CHs4h0+hxEjf145uPB4l9q7wkU+nXY6CuQEGtMe4vKbN33hD+ICyPVWM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466753b1-3dd3-4d01-e9d4-08dc9ca2cc71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 03:30:20.9949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSVmZ34vg45ia2F8fh7fkZYZUXKt4kdxf9vX0Ltz++fBQnaqq1fSGT8YsM1mS4fVmzx80ZtZ4fW69gyhj68pEOsbeuc/oU4i9IB8TPP6K/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050024
X-Proofpoint-GUID: huJfSQhB0_b8VCgYI1POVEu_equnljdJ
X-Proofpoint-ORIG-GUID: huJfSQhB0_b8VCgYI1POVEu_equnljdJ


Damien,

> Here is a set of patches based on block/for-next to remove the
> emulation for zone reset all from the block layer and move it to
> device mapper. This is done because device mapper is the only zoned
> device driver that does not natively support REQ_OP_ZONE_RESET_ALL.
> With this change, the emulation that may be required depending on a
> mapped device zone mapping is moved to device mapper and the reset all
> feature (BLK_FEAT_ZONE_RESETALL) can be deleted, as well as all the
> code handling this feature in blk-zoned.c. The DM-based handling of
> REQ_OP_ZONE_RESET_ALL can also be much faster than the block layer
> emulation as that operation can be forwarded as is to targets mapping
> all sequential write required zones.

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
