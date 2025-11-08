Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B1714F70;
	Sat,  8 Nov 2025 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762621409; cv=fail; b=qkOZawLu+f/4OgRPW47H91xJaWZLTmEQgsm5NxQRRTbMqpbg403o4s140HZYirVPba145dvXYwKZcFzfMOQ7pworHsHxucaL2FeenF3T2vBXceqGmOGao3keSivSGzEl0HDsP3fxTK+yC0+5+EE8NdI9/FceHPjkzDX78WdfjLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762621409; c=relaxed/simple;
	bh=jsrKitOJ19gbqOTJTPrYAXX3xpw703tEifWJq62393k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ux6QZBGFk8s0xWHf2Fu3lljG/nWaYKrD4sXUbAJ1igJ0NoZqPO/qtHxySYLlzJ98BB+xII0dfsoSOY4p132npqlQuuoKy7PK7IHfkzrQVjImT36yMP8ArJ46HJQemiCpwHLOGg5knMLJzaAMIf4X6yEDr4lVnwhnuST9tjq1MUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O0ak4FwN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o9BJf+V6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O0ak4FwN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o9BJf+V6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8Gj7f2004131;
	Sat, 8 Nov 2025 17:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ER6f1HdC5t2IAwI/a1
	iH7aQ8czRY/CtErnu+nZ+uNl4=; b=O0ak4FwNHlAHAnICmTygLVnQjQmDMtbl9J
	YzQL2EtXQavVyRy/YJxdDJsMxg0B+Zh9GJ5H06PtL6pWZU5TLRavMnJXOKKTna8C
	MJaXJv0kNjJhf3bE5zJyYSmRLCx7AlYLzdn1mwcJJ797mmBU497TMMwai49EJBhz
	dP3EyePP2gl3cWveQg0jyX3KcCUNwswPKzx8HqaZ2tRtK4Gy9UYRxGZ23jkC7zVI
	9A1fW6jlqgfykBixNEV7/N5XPAtNGma5y9tZp0QQjq9Z+S5PsbTfesfWar4e0BPl
	fnVQxcPUlmTM0O+35tpnutliip3meHm7xn9PvH8+U/SCWdXvmfTg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa0jy8eqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:03:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GhK9D010107;
	Sat, 8 Nov 2025 17:03:08 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010063.outbound.protection.outlook.com [52.101.201.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vagehay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:03:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wbn9zUR0Xi9D7ynBbX1p3Rzf6F3NcbcPOo8Ekcm4pbITLv6SAiFlS+PHGhIj9UBw1AH90UM6IXF0Le4DmzTTl9Wfww8L41xqiLZMigDXlYMY6kyte5HCXYaIbpU/lF+fdTu438Rw7NvL3qs9SddWpblsdHWYghQMZ08AhlbUVPymgZN9G4kxpwZH9QhbHqaMo4vFK4troIVHBB0H++gHb0TZPRGJGmKEo+pIvOS3tD17WV8XPvHg3X9T2p8clWrRf0r4gkLyJnKpM/dTYyn5Lxe02Y7U07EhTcCqEFwBftq0K2y/FLuMp76sjwMkljcIXkEHTHWRkQpsKhet7Pz7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER6f1HdC5t2IAwI/a1iH7aQ8czRY/CtErnu+nZ+uNl4=;
 b=WMTNMlj4CZ5bu1oYnoOctqoSSKoqlJuFmG6nBNZ0fVEPsOut9gFEcKsYklXvwyR0edUme8giDAg3yTsdYcEncGQoh/y5J3pj8o9dNFhkQvIVrcru1HG+3QK8DDZSgQ1R6zh1fWTK8WcDwReYMSEW8QpInCzYfxVsM1RpK+6ne9dOInoNPzEMt11D1X8jX9X1ftFpRlEZjvOYCHeFhQvlslSdFgMRLU8cGgtoKm5meAx9++o9bHzEFD/RrSmx+Az9DuDFU9tbxfPU4EUMV+sp/AWj0U8jiGswwwg6K56qOoYPRTjpks4WbV8uToX52jmG/MWrD/SQBZhZCFdviWCjWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER6f1HdC5t2IAwI/a1iH7aQ8czRY/CtErnu+nZ+uNl4=;
 b=o9BJf+V6EJxGgUtEL/Du+IgStueaRNy+VBhXuq9IitPCvsG6HwLruH1FIyZDUPqSMB7ihzu7cZmpXuwtuST+qZfdfU1cTnYL2pCI0lY2R0zaDvndeg6BLYEPpK0D1TpZS6v1Hhep7yuT2jASIXhzxM3YL7ucaIJ++MckebYhHA0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4857.namprd10.prod.outlook.com (2603:10b6:610:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Sat, 8 Nov
 2025 17:03:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:03:05 +0000
To: Tony Battersby <tonyb@cybernetics.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi
 <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
        scst-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        Xose Vazquez Perez
 <xose.vazquez@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh
 Javali <njavali@marvell.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 00/16] qla2xxx target mode improvements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <a6b8713e-c499-4fce-9964-9f277b24ebe9@cybernetics.com> (Tony
	Battersby's message of "Mon, 3 Nov 2025 10:44:32 -0500")
Organization: Oracle Corporation
Message-ID: <yq1seeojwbf.fsf@ca-mkp.ca.oracle.com>
References: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
	<a6b8713e-c499-4fce-9964-9f277b24ebe9@cybernetics.com>
Date: Sat, 08 Nov 2025 12:03:00 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4857:EE_
X-MS-Office365-Filtering-Correlation-Id: 53f66419-3249-4d67-ff20-08de1ee8ae0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lIJuhOFyN7BkibdzUJh+NvdnDIqLRoZNSUuejgFVetYIlI6wGj9E4Jdz6aMW?=
 =?us-ascii?Q?54i30uNzAV/5KN7HWTHBnn53Uo6xalJK5qvaZya0C31nnuUWRIctKRbTWgYd?=
 =?us-ascii?Q?SDpxYF6R7z0k1h//95fHezgf52InXZ7R75nW3l/wVALhDYFzmaaujDpnYiJo?=
 =?us-ascii?Q?qfu4b7MoZDKb+OqWQca3BXC3QTVUhlmHI4za7c1ayZ9cGvVFA/JD3176FbpS?=
 =?us-ascii?Q?MpvD/lVxXywNU0XKgZXQrDK5QHJOWcCDv9YKhzfZIlAlHwcAe5veYD62c0sF?=
 =?us-ascii?Q?lSuNyVMJXieVqDgo6fuu42RNpm4q43MXhZMiMtVGCrdQnu0YMpmmP72ZuVoF?=
 =?us-ascii?Q?BQnBUWBB5s7sjSV55le1ud2CnxVN5U3Wbvrg7CC389MGdVJKN/Vo07f0hlGv?=
 =?us-ascii?Q?5FuiKFfCaHRI5eexwvIn1VtNLgjWgXSRIwDKhhWrAPxr60LH8DhxeakQvG9+?=
 =?us-ascii?Q?3AABr3DBmCefGzHYcL2aIyfTmorsLszLfaUHJSlGj2QHymWJGjCRvkEPWZcS?=
 =?us-ascii?Q?Xdr5/fLGPZtofid3XYO3FO6Eu3OahiHvxFRY69GHevSm3FKJu/N4bbnrfdXF?=
 =?us-ascii?Q?9sCdd1E6M3PT/L2QpGCrYEqWwckPqjYKhpeQM0K3TVKg6177GiFNQf8Ctaru?=
 =?us-ascii?Q?pniI6F+2ChhypzU/ndUXjjFPbuLiZbrkbojbkm29xKL9+qnN8jhR0p+3qZrM?=
 =?us-ascii?Q?NZqfbeqBO9I5AV1/GmJhy587a6I15KgufGhHYhtEZLgsTRZ9bCUIPYysrcDf?=
 =?us-ascii?Q?2hwaep+XbQL70xtFD8aHRl7T/YWQOnIlOlUtPwr2fWHmPfwDlBpARmy05G+V?=
 =?us-ascii?Q?SMMXlTbmK/UhSwL1/oX1jo/cpDFyuaQUiJqIBubPE3x8rvJLmYzPw2FoQwFR?=
 =?us-ascii?Q?TZxHYRlYv/4IRb7Tg9MqQZSGIcod5zM2fYonRGUN59Zzv9wkAV8C1nsEskkC?=
 =?us-ascii?Q?85ow+t5XR8net/iYFUMtFyq0sJkcsDd2GyvJXlp8kzcDEEjHJKbK6HZATL3x?=
 =?us-ascii?Q?Ff7vciQ54B1Ls4gEqVCBOldufpePPHoDNyA9OR2MhSV+ixDfMOacc6NS6pM+?=
 =?us-ascii?Q?u8mx9YWtM1PpxE57E8vuuB82DxKG/YtMcl7ZTfbMstSIJi6mHyWdnkSW5hv1?=
 =?us-ascii?Q?ycnzZphyFhRW+Fd+4ZPYmAHtgINKmPrPRNXfEDCb1tuO/mfSSmF0ukBS1P06?=
 =?us-ascii?Q?alc2nQqqHD7dUhJaSCvaXEpzJHSthdgmlXv3VClkToTJ2vanUFgCYr7Xixjx?=
 =?us-ascii?Q?i6ShuOHdJkgpOnjxIYFKdAID41vgrdfKtIQw5LidzDs+l6A2hl1mi4qpl74/?=
 =?us-ascii?Q?9YAWXAumDV14geHBMoqBlJNbKCJbNPp5qzczqdPat/N/2p+mIwwZ7UyZ5oer?=
 =?us-ascii?Q?YkrujieAL8BAeydkxX9/JkE1+VComsQrUZgvbSmo1m7VNDan9pUHS85Y2NDr?=
 =?us-ascii?Q?T8B3vI8GJVslXFId9UFDQgNXzzF3tO3P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WZsiARPnxpm7jdB7ZHy1Uvp3SMe9epWpICOd31a7YObYX1WYSqcd2cl5OroH?=
 =?us-ascii?Q?iz5aECyWBMMHSlvYYaqIImxdA4/3OvdPyIK0TkAMRZHaaN40jnEQZPkwmpk4?=
 =?us-ascii?Q?xn4sMcM4vg9kL9U6w1nz8M9pcDeJZkDxVUWAhEfO6Qt368mgo6n/eidZVW+O?=
 =?us-ascii?Q?PSjVmKUxLYszoD9VW0uTNjPtB8L51VM2ka+JbXR3BJqP+eHchH9mzg38QGOk?=
 =?us-ascii?Q?Oc8IYEjQ/c5UYPQEMAHbhEY4JuasflXBR2hrK2qgFu15mbKewJsISCsiQ0zw?=
 =?us-ascii?Q?05Y7ELUuVu60XI8cW13/9m8uXQz4/zlHkK+fZGXrWH5Gjqv58wcCVw0webR7?=
 =?us-ascii?Q?gKVs9Nk4rMA0zsPO/j3jx6KNZ3BnCRD76cV94A50oXsTszXpXXrdRKWMHBXO?=
 =?us-ascii?Q?/GdmIIs8Fm0GAZ8sEK8z5Ec60L8hAgBfbYiuzXXgY+/ufVWaLCWtzVw8Yl/I?=
 =?us-ascii?Q?6QEpGplUabJv1LgtTyestos/eiYt5fxo2Hka9dXUu1hTmD4pmlkOAZYEmXb7?=
 =?us-ascii?Q?3uoVoWRwVTN/H8Jhuk/USnjmr+R1SAtcJAPYaTkLvHPctIJ5+BkRrKK80v6g?=
 =?us-ascii?Q?RF5CGgOjffdejkgIB20gF6PMduo+c5s/BReDh5XTV7FoLV6EpS5HyPmfKS66?=
 =?us-ascii?Q?9QFsYuK2liPL/ZEfu0Da7SFYut2KffLBHA/pZhrS3ipOAW+npkgRHXhIi5GJ?=
 =?us-ascii?Q?rzYriNDcQeUd/o/t+bRrYQdBeNf2tY/TGXNFHod+Bs9QGRFDepzYrxZzFru2?=
 =?us-ascii?Q?nF26MWryC4WfbECsWNfflckmmxN8z4yi7LXQ5+zlxG9MyaDtUNfVrqCKxk/h?=
 =?us-ascii?Q?Hz9B5E1v0flPYnD0ah8fYgLMJM2R/6AKI5hJt9JUszjH3ykQJqAC46ESxQ+V?=
 =?us-ascii?Q?nr/RY7Kxc+qFq0C5wWOCvQCqwq0lnwGyTcf5TXP/Eb6ZOthIRex9PiQ+qykN?=
 =?us-ascii?Q?r4z2PU+XM4+pYuGf8XN5+CHnlkUIYDvh/aNzd5zW0CqMvCT8QHFixTUoonAB?=
 =?us-ascii?Q?kLTUzyR5YQB51jY1RxpeVDg4Og0pQAYzwtuQl8CNzcwURAIpjPEkVSyg+yWp?=
 =?us-ascii?Q?0izf5SheRfGbeH/rsrA6c5qoPPkXcUWJSHPekYUjbfLbnJmL51n/1tsQrQZG?=
 =?us-ascii?Q?5JglqVSkw3xoYxis4mfkXO6nj+loFrffQBazMavbQvbVZMXW9ut8gPXfae6t?=
 =?us-ascii?Q?JJSFHlryRHqS/32P0YAN7zY4Sku6fnJ+1rRIg2g8MQf1vvpa6vOdgo5RNss9?=
 =?us-ascii?Q?IQG3AwpFGFSVI07GMs0fC2UA7vETGFMutxBLbMlLiF42zAOaNyV5Breb26Zx?=
 =?us-ascii?Q?nO+BSZEHmqIhRVA8sD2HMWLiTquctQIp6OakhiKd3D4K14FJlKJ3BJaF2hrW?=
 =?us-ascii?Q?C/vpQztt6kz/h4aI56YRfo7uFYjZJDKqwC1Jho7g/I+EfGQNGDQ3fAl4sMtM?=
 =?us-ascii?Q?0yL9rvh1Kvt4s/pExkKb/2pkGf+q+np6kkGfROqzxJHaYuq0+TFnIs1nCxCU?=
 =?us-ascii?Q?ScvD77dYyWeUCmZAnRBnb9O7QaBHLV5ywPkMCHbc0XVi9jYt3HNlzeYKQkrl?=
 =?us-ascii?Q?tYi17/OwPcqUriW0I7f4L+YCDVmH8txgl/n8Nrbhn97cIINdbKc9Fmu/lD5P?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qAg8GjgXStQVVa5JLyVt70FV/Uea6/nZ6KkCF6TEhi/Q5j/WpMtaU+QRZU1cCiqOsIO7W40YVjbmvTrgrbUYa6XwnHLZbZrDDE0+CKnRtioVrax+UecVWOs8bp/FIUtZzuwyrlqnqBjO+Us/GnmV5Kk0FMQiVdShvMgQ33RqB0xWwr3bWMIjs6c6lU8iOiL2vxjqFFC5L9JHh5uZaA7bPzOHEKkuKFROs/hbYtWdCvLX/5izJoImOIi9AsEj0mndGDFZ237+5O7GoTxPlnE/qqATeJanwMVM829Gq/hfhLYB/4pjc64SRFu/jkGl+yOeEk8i2CG9gi4AVQ5955TuFotEVjHZ7dQvlqBuRskeYnruUZWwmynM6YyG+LoQu3zY6AT4SxjdPdokeCLtMuZem9yBmI17TYJdI+pswiaIr0RwAUu61HawBXyXxY8JMMXw+w4b7tQ5yVz7xf4KqRNO/N7J5ZD0lXTAPJqgxsTaw1WbqbfXszMcti6W15ot+dXqvI3W1+3PzmN3y/NiqWwrsnS2M2tPKNOQbgV+odKuS40pZ2YFECJAZbW17p7QYA94a4atYQH2uW+opS8e3B6vEcQUDR6tegbLxNAAPAtxRoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f66419-3249-4d67-ff20-08de1ee8ae0d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:03:05.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJ9sVh10DfiHqbn3YK/XUIoUyGmpgSRVO7YG1K0OOyTIghLz2ph34jsVTqZc6qV7gVRE7guIZ4ttdrFwC/YXkWYqxh1zOR6WYhmnGjXE0FQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=702 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080137
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA1MCBTYWx0ZWRfX9Y8s8TtH4Rt2
 RTKwIQ32ChQSi65EkaZzoGtZA1eQZUIKKb7iEW5tcvpN1UTegVovkSYMpctYVreRmCfmIGp1jfN
 G+D0MfKAGVGD8L4HvSa6IYJfG4ZmEekuxa2PuB7dSblzwfWdMULfzt/SoBZZx2OZFhDt9RM4TxA
 7xnwDT0xmbNvp2bqAr+jfgbuw3eakBeTCP1Sbz65AewLsgf4522PfLkxtq07P6mgihS8+iTqXaA
 9rPYI9n03gjHZjQDmuZdmFpKtapkUmK5lxdWoagoUiDdN1+yNuVE9PPajV9xE9Q5oRghTOjuSc+
 Nu6eVA5+1VHZHqQChJZ8vF2FidzadavOaJFcmM+OSz/mpQ5ShuDv4q1f2/bM8tL+W508cAWEqAj
 E6GaQELPuWxFpJahw8RtcK5vf70gL1jEAB43Ji9EWI/ifIoHbNY=
X-Proofpoint-ORIG-GUID: q8Qs7wRQEqb8IrdPmd5FjcNUBVP_8BtL
X-Authority-Analysis: v=2.4 cv=IpkTsb/g c=1 sm=1 tr=0 ts=690f77cf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=o6qjiBGnyEjyxpUkitMA:9 cc=ntf
 awl=host:12097
X-Proofpoint-GUID: q8Qs7wRQEqb8IrdPmd5FjcNUBVP_8BtL


Tony,

> Could you apply this patch series for 6.19? I have addressed all
> review comments and no one has given me any objections. All patches
> are on v2 except patch #11 which is on v3.

b4 and patchwork doesn't know how to deal with this mix of SCST and
kernel changes.

Please post a v3 series which only has the Linux bits.

Thanks!

-- 
Martin K. Petersen
