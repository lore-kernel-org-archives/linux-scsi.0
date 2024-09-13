Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E31CCEF7;
	Fri, 13 Sep 2024 02:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192876; cv=fail; b=VDuIpMU3srrQZ2BsOSjrlozKlzD268G3jUn+GBubG9ZJneBlM27FXFTwRRO0lNkUyyJTkmY0TlrKUxnA936nrtMkif9IdoHh/3zxNLQmywGoMvlW0nd2woYGxue+TIL2Ya1Jc0mRPVwaVKeEdedztupl9uoH1qJ+Ov4ZuuwiJww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192876; c=relaxed/simple;
	bh=sPn9CGlnpisne6Y6YHCy68wVxuYJt/MAOQxpHq2cqU4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gPiUgMRjY7ZrKJQ3acGK0PaVXNoFPXtN4+SnKj3GRocg7Zl+LBBmgpbrNTqvfRzmfvyFB4oK59bvWKd4gS1XKLyfMk8pXKpoeTFxRSazwwnYxdmgg1e/uE+hMrI9cE9czh6Nv1Ppnpxv6qG9GWYK32C05+rBmQ8C4nFwVbivRpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ehkpOxEq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bBgm+0en; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ehkpOxEq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bBgm+0en"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBa6L007355;
	Fri, 13 Sep 2024 02:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=2s/CkxO/8OZr56
	8oyJL1dZs2M9z+zDWcM0916KdpKxY=; b=ehkpOxEq8HuGNoEbMS3grC1B+jC21Q
	egC8M937cFRycjx4t1fu8OpG2y4ot0xnLm1PHPu2tjuPyxuEN48gDgs/O+ucQb64
	LDrko1yYTU5l1DFm4xjTzVd/IWJ+4OY7RpzbhxLSzboXBed4SeQwo1xsn1oV4jEP
	EpvdDL6Vxf99K51OpHQIeCoyYlEFy7MB950UUuC3oxNqU4yQsBTKxIKezAtpgYX3
	3ePOV6X75NV6C5Fzr9DDqc2SZmiATEWVMxhSRC+AndYP6/SuufbxxtP/DzAp4Kh2
	KnRDe8887y+88BlwlzNVk8paLnxF1J6V6+pb9a65KcK/IA30EgFa6OIw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9v78a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 02:00:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D04Sdo040909;
	Fri, 13 Sep 2024 02:00:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9dq04u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 02:00:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TruOptsKLN+Nf+lfhDHyp9WuC24LhD3F+rbUXNlDJc8xi14yz5XSUXCxxgFw9ztrT5AqMugR4T561pu5dzgjmkPkpSCqT8B4IV30xvYZ7sGrQy/oB3W2sPLzq4PPlzlPScnf0FzF2TGHeKPsmSbkACddYVzxTlGN+3CdrxecJx4FZWkIAlUNUItfaFw6r83ZfJ+NYUMJBqhd2GNZrwjzwpZARIRx655Q+LjpwPk4iWkXjhYO+sw2DvUauUuBQVboDHYpIL9fNBEEyZhaBmSb0YuwlcUeSvEXefTxhxgtItMDiF8KXN/6MJLXT/yLuKs3exTc8+PiFWXVDMHlEJxv8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2s/CkxO/8OZr568oyJL1dZs2M9z+zDWcM0916KdpKxY=;
 b=eDUfbQCQw0vvHYV19LpQTuUBJjXiLCKupRXE2D3i/BMF0TnxWVL0M6vDFTUaYPY6rEX30sORs3SqD4fGKKBFTF635lBAkI+CNtUOUWOoMO0Ly81p564vdBMZ3At0l7LNT9P1aCJntEuKJWYltwmEECPLIO0mlUUgK23Z1RefYQBhVWim0YYaT1rFUBVJ1XyKJClckYqYSWHhnHe6XuVn46Bf2AD0SbPKHBVEK2PQzwAhXBBhUCVPbvyF3ybfwt2Lr0v2nPv3kUMDv7boFWpQz8mgevYwFTbtr6zzX/kqO1LOjxKUsjDsntwDYfhrwPv7CwVyGNk1kdtCVzbkbE1FZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2s/CkxO/8OZr568oyJL1dZs2M9z+zDWcM0916KdpKxY=;
 b=bBgm+0enCkEREAbG1fTzOu2vy5gIG6zWBJaTpsorLevB7nz3kqUg88XHsLPe98fOV2vmcxRy3QBbHJWBWpxoOI1U5NqqKgAuBL7ghzZgYIi7K77wJ0P6H4CwQ0Kctzpu8SmiQzCmx0q2B3UX3k+bHzoRA8mEWy/xBzBlbOUuwg0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5578.namprd10.prod.outlook.com (2603:10b6:510:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 02:00:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 02:00:53 +0000
To: Keith Busch <kbusch@meta.com>
Cc: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>,
        Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCHv4 10/10] blk-integrity: improved sg segment mapping
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240911201240.3982856-11-kbusch@meta.com> (Keith Busch's
	message of "Wed, 11 Sep 2024 13:12:40 -0700")
Organization: Oracle Corporation
Message-ID: <yq1frq4tj08.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-11-kbusch@meta.com>
Date: Thu, 12 Sep 2024 22:00:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0720.namprd03.prod.outlook.com
 (2603:10b6:408:ef::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5578:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc37422-a699-4eaa-1679-08dcd397e645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fqR9BR6ob0W46Z0UWTZRJrsJB9VzhxLOnIxB66GSs7ytJ3WCruxSaZeMMdPs?=
 =?us-ascii?Q?Vkv0MIdbvFysSg0dK2ASw8AeUuSq4GBq8ikjq+d7c3Vf52f4WznOhY4mGCdi?=
 =?us-ascii?Q?fZo2M32GiORjUICwxgLtL9nUZkhKbGc8uwvlchScClv3fAwo5v0GA/TwmZMp?=
 =?us-ascii?Q?JpFxPAujQSDu8TykiOiY2hbgKqkp82YP4/U3uBTum/y2XOUO6SDLVyM5JAPa?=
 =?us-ascii?Q?Hj/9ctNXqp+KoxP/MEtpye63Om35He0Atvc2gBUhVnBEOPA8Hev52uyzqTud?=
 =?us-ascii?Q?vkd80KjzABWems0krB0+gBgl7J1c68mb4IUvPYEfmPvQp39IjQCLzlwUqNJy?=
 =?us-ascii?Q?effxvxQtNNON4LOs2ouzrr5nbjuWfCUQ7uyPjMyKfJQUJXY7oWtvZgwBCmqw?=
 =?us-ascii?Q?dAeIg1wAt1trps1vGWC2MSjR3UHjMaknV7+qWJDdQeXwnBPfy+IwqPrwcfdI?=
 =?us-ascii?Q?TB9e1BiODA0IGtCGWYmJaMY8fxwgPbfWvwjJNwyhIxKG0VDv+ffCPM4TS0/B?=
 =?us-ascii?Q?8DcEm949aVRxkRii/cglLT41SKRxyB+peO9QPe45HWmd4sDGApI4mUFOTG85?=
 =?us-ascii?Q?HxqGaob7Xx4oC3JYO6XbwzzKbmFySo9Y2t46Obnc54Q7ZFJsFJSGjDyuJi11?=
 =?us-ascii?Q?GL+vEJJO1BfkbXuVFnQkHO1Bx+PrBt99r0Afu5uPKtUc48sBenqXTKiEKLVg?=
 =?us-ascii?Q?p3D+dKxywRVjqDnyi6epCMgsM6LxDCwM1zBpxvvpMFfTKejaTSB9Nowa0eZi?=
 =?us-ascii?Q?h1xTSKk7zdke4bkdPBodQiG2slmnsCr0vhbehhQZf3WKUSPkO/Tp2lkdhfYf?=
 =?us-ascii?Q?nu1rdCyvF/l2vES1bhrjOggDcLkkQ3MFQCLBfwna1nl4admT1QqajOjsozQ/?=
 =?us-ascii?Q?5IEMCy5FctJNmegu5U8Syoh6RjFu0Pd1tM2+ZnRWd3n0xzYRptG1SRQMYnVL?=
 =?us-ascii?Q?EMcOaMzRUsN77QALUSv92i9iZ+YAehVAb2yfH0cG9uoamy+19LhBSlBcNXVt?=
 =?us-ascii?Q?+xv8oOX4eXc2e+ilagUfFeEoAPk50pZPk/UQLmcHR7UGDmaZgwsRXNRKaL5H?=
 =?us-ascii?Q?hIJUK6XnVYt1BLFBR6eBQz6EAOL97K/Zg8it4cRo3ceXBdu2UxntM8Ak+yy5?=
 =?us-ascii?Q?ch3vjIe7RlhKTwCnME7wjCbBZD4FPqpEyJ6E4JfeBzR8n88CM7JZd9kj8PHE?=
 =?us-ascii?Q?wEUWycPDraUxA6ZQI53+TqXr4MBaGK5FoaP6kdlHI1IsfeLzUQh+2skmSFwL?=
 =?us-ascii?Q?uPQAfMBDg5CUZlFJMF3FoTzZ94lCwDEPSn34tFnomNXmXQvGovxZxxZsuTMe?=
 =?us-ascii?Q?IlBiuPXIQID8yaOmGCQUtRi0e8SwIr51Pa2ooXBaoE8Hqg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ssC104s+qbmm2LUc29+71nbC0iaY+KSjDj49cNfJi5oK1g+fWYO6ztJ4VGp+?=
 =?us-ascii?Q?n9GsfJLDG9P80hg9DnQmu7nTuGiQAq/CCJUby2rep6e73g+5lxZRAk3l7Qnh?=
 =?us-ascii?Q?VLVzNdzT28y5FCnxcUHk1/BspH/NeVP1LZUxG0HORkzj6mQNKxr2MqIO/PE5?=
 =?us-ascii?Q?4EPe2n9RrDHwXlCLj4kFE1QIdDs7onw3AyJX7zWCGMbfmOvSE+6e9Ol66TR5?=
 =?us-ascii?Q?Wrlvy64CQdks7QhWkGnKm5fZ2rw6Om7v+QNXMRlO4f4JDGHh68H+VtUZbhik?=
 =?us-ascii?Q?WHb59kYf9yfVwqp4Kny8j/0AABGZ/Py3in9psEzbVwbXZ2LmmqqfS9+prFKi?=
 =?us-ascii?Q?dmAd1VwISp+xwRzh0gr6h1rQ38A4OLTGqkqM5qmSUN60HHU6xqjAC6gg8cY7?=
 =?us-ascii?Q?LehyloihTxMKc6bk9HnNWxbY/Iapt+Yr/VNqbvG/qaO9kMf6IOWpfU+yHT4e?=
 =?us-ascii?Q?bjo8k4syVKnS1ccRl6tER99PGanxVCPATy3uDuASSxLErHhanDTD0Wc95Hpy?=
 =?us-ascii?Q?CfZJ+pfRA1YOAevNw76Db3pJOayg1HzTz3qPR0sSrv3nfRrRclolkyPA70g0?=
 =?us-ascii?Q?7yQpQx2B4dconOzyF4kaa0uAffdjSrTheoUjZaEjPQePx6/UlGf+woZ3xHQG?=
 =?us-ascii?Q?7GpHUKxCmOwISKF4MnYw2LmQbByvDecQZmp2Ut9RWtWdkWEaBUcYSeD6aN57?=
 =?us-ascii?Q?NIKslpB6etD3B9ZsKvzydVCYdml9I56kjWxspjWYe57ijmxUlsp50UxFrHLP?=
 =?us-ascii?Q?IeVGGf6ZN8YZnDYY8tmHEOsgPWOoft38qKwO9ebHiJai9XlJoeRPghsBZDZY?=
 =?us-ascii?Q?wbP/DE4oVkE8vzLjCyXYHvKMK4gUJ8mKoMYWAXoDn8fljYJZZKxAScq1ZBgM?=
 =?us-ascii?Q?reCuTdUnHI55+ytyaLk1PIBUkwUQ/hOaXEnK+rifa9m6LVpzqR5aAXtofdb5?=
 =?us-ascii?Q?oQLa4L4agTJU0KR2nnscbgH5uihdBiInEzQKb2RfiSJ8pdn9+NKM9yzkFQ24?=
 =?us-ascii?Q?WYxBrkbXwo4M/fVm/fhuRwEH1rK0R1zWb4scZw79dlWB+1sRvawAvRQCuUVN?=
 =?us-ascii?Q?9znxkzIorSH3+H9lVNPQ2ttG20we1aqwlgCulVl1aDG4e1Ho3BQ4An7zGlR9?=
 =?us-ascii?Q?f0AYxC6Zt7DWJXr6PbkKoZeI8+2oOXMpUhusZFmFRHnqApcPtFMocLtz54J0?=
 =?us-ascii?Q?5kpN7GH7FURrpv8tzYwC+HuWui7JNVpMesVF0B5bkjaosKz35mxhqc4ampyS?=
 =?us-ascii?Q?FIHOw36tdzPFmJeQonjR4/xSC9+1h9FxdUbw0Bvm1+ZPaYAyztdf2Cgyibtz?=
 =?us-ascii?Q?lJqcPwI0cfNgqyH7MlKzgzHLw7oqpW7gZq7qPqbyvzvKAyMK/lFUJi/gOVhg?=
 =?us-ascii?Q?mhGt7GEk2mjWEN9IDpv/Q4skZv1ZUZyqP1JetOzqR8Uv5OIPzZtWfLZVftl8?=
 =?us-ascii?Q?8MufqYvlXt76l3m/l2unJwHqKaWaoBAzeJrYDEgzVvLHO5Bq2YGVLZ4m6KeS?=
 =?us-ascii?Q?d030hq6tDk5S4+1go5R9x0lbXfKYKcjeZmTI9D1fLj7YRMJ1hGze9RMi0KoH?=
 =?us-ascii?Q?sNLUGy0jFPQgbn9ko9oudZvS+tBXj8Djme3gX3CFsGTN8QqMyt8iQo44F6hM?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G8tYSFBsQWFwtQ+NTidLHMOoOynjOglWcFwpBp1APOORTd9+SAz8kEhuBeaM9O7u10UHSw1jCiAeArniXlw2/4uzRSYHrlRVycN/LqxL9sAVpDIrEC5Pm9k4xUXL/7TYywyZylqDAo9NHKu+gsumXm47xLp9PJArLSBbP34dmFAAXjN8I8t1/UPiQnnVOdrVwD8oVcjTerQHReZhjt8tgRq5XQFtMmdIawK/HwGZIrv/M5ioARxbByNZMMJ5vpQulGCww8QVjYm9HR1IUgnA2akPqURasoQH9ufA1oEtMmEMjwQEPTA3n5huimssR+vOSvCK0mTUrOYAEOkukkeBGTO7P/sI83w5eZwUZ4/iSaBbgJ5Vmmd/3fU3T+jXLb8GDheAqcnSy+U2vZsfTL2dzttejhyJR3iv3AtoGb5UjgkpfPmHpsHvMQqIpGY+vOoLIPVsjPTHvnHuYZqpBNJuNL12vAwABgHkvpN6AhzL9nrIC0rPG/7xxVPyY/jSWkZzvA5hrudeBjHrOkJpVjKnbei/XW13o5LnQyz0i7Ug6iGqOS75BrOiAHowAzhyS7YDolNah+LHgjaewm1A9P3RJGI/tj/SBM2Iin3Abz+rhIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc37422-a699-4eaa-1679-08dcd397e645
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 02:00:53.7733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6wtBC4nSl4GBi1890+bV7fHciM7cwDEU10Hn5Pw6Uoh4Df0zT3qehcnp81bUsvLecSFZ38rYXK/zgZhlNuO9jaZbEsY9mAQGtBEStyUufs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=710 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130014
X-Proofpoint-ORIG-GUID: cLbAGHcxzTqT4A4dF1D7rxs-Y2oMwElg
X-Proofpoint-GUID: cLbAGHcxzTqT4A4dF1D7rxs-Y2oMwElg


Keith,

> Make the integrity mapping more like data mapping, blk_rq_map_sg. Use
> the request to validate the segment count, and update the callers so
> they don't have to.

Looks OK except for the phys vs. integrity snafu.

It has been a constant source of problems that we haven't been able to
have a common mapping function that works for both data and metadata.
blk_rq_map_sg() and blk_rq_map_integrity_sg() always seem to get out of
sync in peculiar ways.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
