Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01391290F;
	Fri, 27 Sep 2024 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727402519; cv=fail; b=ecCgkNufYQO+TNgGLEuBfY2OohUNb0rnsYKFLR5Q97A+utXw4haYiR6v0hRODDmwsy2kHfY9PwETiZI/PaNGaBmwRx9n4eMPLUPXNMLMIg01eNy3DRUU9mHnSE7vYOJWbDfx71vjLswn7yyC1/VrXNvD89aRtj+ujjOQrszS8YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727402519; c=relaxed/simple;
	bh=alYXqaLFJQ5GHfJXkN+CPVFgYathF92hZYZH+RVDxDo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uWGRHgnAZWYLVIKj2SV0FElCNTtZdHgYNzypW2yjLUHdok5C6hvgk++q63IBtojavXUC0mgGbb49GBpE4Aye2kFRskLKtn5PAph6hDrYz8mFU8/SoIk1RJTKBOfCD21A0JcZJrbV+e2oDi6kzqMsSj0UskOWvYRXHdS78eGmsuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KF9+FT2A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GNNHTqDh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KF9+FT2A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GNNHTqDh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48R1ti4t004512;
	Fri, 27 Sep 2024 02:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=+tozmucOLqR1H2
	kVSwsj59pO6dB23pXX8s1UefLhDdg=; b=KF9+FT2A1OZ1hR0ZCc3nC/O+5TljJb
	o8/TyMd6SIt09Syen1NjHTbEi5ePoZkEEB6loC8f/7XDPyzAF6YxhH3hXKNuoihU
	s20pgikP63MRurxwP5qos7f9BrGdG1nC9lttFlO+JcYnzIui5itbH4KU1wCDk6Dp
	ta8l23e2opH8KjfIrlKVCaAd8Gt63642WEHox8tQexNsEn618l5IhhTWJ7IeKPba
	KcGrjvY5PTwDvBzZnG/CXLEfkS2+xSecGG+wJK622UMMoCVp1eYQwWD/jay+7iHQ
	2PO2w/qZYQXZdfUTiZpIoAD/N2btS/Wxe5iORVB0cHpjL6tZ3bERXpXg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smr1eqsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Sep 2024 02:01:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48R1iCxF030497;
	Fri, 27 Sep 2024 02:01:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkd1400-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Sep 2024 02:01:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wy7NHBth27Q+vdAaS9C3jaBqR2m65XuwhSJcqlRFBSUea6ccQxaUXiZK/DNThVFMeQPnpMcsAcPLEN9zkx53VQX24YFHUXwoReOl0BvOwtlx75JuF/8Hh47NptosW6wsGN8JtfvmgItfKJS9nwF9tIOJqOeFqwWLUO1IvkFVpPpj5Mr45KMIkrvrFqstFlmo+rQktmfhAydUR49Q2W44qpezwQ/SygnjHdza8vB38kuF2hBSEipP06d+eQIlsrnTtiOElt64GDu6LGIeon6WLfGAWJ7yV7weQIXMo0hzDodKIDML0kDhL4y0aUnAKjkGMe80JTQMK1qujDPWgiU1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tozmucOLqR1H2kVSwsj59pO6dB23pXX8s1UefLhDdg=;
 b=cwd8Fmrd+7acY1uY0tGCbBiCLQ1YusFWPHK5NNiF0Kj6FPvPRqe8EH66JEalSwT5DZxf/M4f4zcKyn+WjqMWxqPXnK2nDFxFkbpcGnH7wlbsfeBDkXsjoPCY4uGXJqo0hxe3xkJ9LtYsvU8ugZZec3odL7OnW66WHqYh29rUy3WFVfxdPTt076Qse+iOMBwT29Tkgpz37E09q8AM4AL9o1hNg6hhWY+GfaX/kbvLDkU8spXScfh+DNBtQYFmGxWhglZ2UVcNKoMsCFTCEBS4vVUuyu/LfTc9OoaQbN9354ShdJ4a/kQV8+aQVwe1yPy+tDvCCFLEEfItG8vRubXJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tozmucOLqR1H2kVSwsj59pO6dB23pXX8s1UefLhDdg=;
 b=GNNHTqDhaVGCOepNzqlg3ktiTYW0KIklWonN97dDAWBgm2u6hiVLL2Cbot6kJ+5iXKXdPITtAP28rx79rGUJ2zXc4+lpvc7NPfWShX3xlk98GFTCfJ1N23qVFrFD9Z3bhadN56a1I6JntF8xdtEV1/EY2Yd7qhtycaR+7yRWcQs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5694.namprd10.prod.outlook.com (2603:10b6:a03:3ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.8; Fri, 27 Sep
 2024 02:01:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.005; Fri, 27 Sep 2024
 02:01:37 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anuj Gupta
 <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240924053644.GA10569@lst.de> (Christoph Hellwig's message of
	"Tue, 24 Sep 2024 07:36:44 +0200")
Organization: Oracle Corporation
Message-ID: <yq1frpldfer.fsf@ca-mkp.ca.oracle.com>
References: <20240705083205.2111277-1-hch@lst.de>
	<yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
	<CGME20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8@epcas5p4.samsung.com>
	<20240918063910.hqntgm5jy2jisys2@green245>
	<yq1bk0dhlko.fsf@ca-mkp.ca.oracle.com> <20240924053644.GA10569@lst.de>
Date: Thu, 26 Sep 2024 22:01:35 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB5694:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cdcdb58-68c9-4e7d-f897-08dcde985219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kMN/kV+zYj5yaY+5x4DkknoyUXLmcLX2VwXZL3A30SUB+Nr/OlXpBqHYRo+I?=
 =?us-ascii?Q?fmqrvvYr+PqBPhmesYOOkGTBStrKy9hvMZ2xMmBIKXjouwCFeVPsJfL93Sm0?=
 =?us-ascii?Q?kP/E2pvcBHZbqZLBCwNxpHrJMaF1IPAQ7krJqwzpwJVuNB/dQ88SzXawq2vq?=
 =?us-ascii?Q?S4KfnETvVXKHDWWMvNlt81pScD8Y8pgpAg8HSjYSsaOKicZRRlqAWx+AFngy?=
 =?us-ascii?Q?Vv+HJ5zBK7zLMYCqu1SBX11hofAIiOBvD952B6NtjT6EeopxKMhYUyItVZdU?=
 =?us-ascii?Q?yAid4KVkfPFpeSaD7GgrKTQdXAqXZTwYJrllcWm6YyZtBj5EFVBHW552P5mV?=
 =?us-ascii?Q?34ctGbbIIJq8yttvO/ID1d4jeP+BJ2mZZgC0vpHHqw6iW/R33q+Y78OydCXk?=
 =?us-ascii?Q?CDkxjy0vH5Z5JVkjzsXDJbismj748WKZrMlm29edC1G/VsjdRKHIby7jR5HA?=
 =?us-ascii?Q?ldNjG50zi+Ox3sMFIDpQi9E42jneW/Rjn6MQORZxmon1g/mRZQq3azOsP3qH?=
 =?us-ascii?Q?OChLo/otqFEGH+wRWq3ZActLZDUenU/HyxOcTn4K6urNT0+hEv0KAaWVPKVR?=
 =?us-ascii?Q?Ftunl5ofZoKwL6lWBBD+cWT/H3CfFe32nNlZJY84/H80QrAg0bgFQBkUS7SL?=
 =?us-ascii?Q?3FFIVRZ5GwNhtbUkxvlvrUxOOnLVNWMni2aj7rC1Fvhq7XDzvITjivKBU4cr?=
 =?us-ascii?Q?fDKkYX4GQZomNe+6LdfvUQoTrubjbLLMr6DVQ5iYpVap+XCAHjEwCK5v30Xs?=
 =?us-ascii?Q?n6kabayoJWZ2IwyYz8UiErBKCbTwGk5K1LJe+aLyH5anJm0GY0aUmpLH5LnA?=
 =?us-ascii?Q?EoQ8nIjSatF0opfCR7GRLi5QC3olgd/ccRIHRwHvwm7ZJTaQG5nWPQSh9CSf?=
 =?us-ascii?Q?q+348gSSlm9mQ64DCzw0GAa6/EdYcGRFs9dn+6vxRqZYMYd4M3QxED4/AEc6?=
 =?us-ascii?Q?soYofT71YAxOc/2pSs1tpbwPvDXS0nSr+yc5BNBlGQ4wd8kq6HaJrysA9Nvg?=
 =?us-ascii?Q?Zv0LE4QEBYyc7qRMXx0PE/UWrn5LagHkyOpWfqGxlta2lN3bCH/IVPTcZ+0J?=
 =?us-ascii?Q?d/GQCMD4qYNNouxJ0wKfrcgbSOCFzKeQjqN+tDh2euGVl80TZ+qVFP3lx+ez?=
 =?us-ascii?Q?pDGTP83YUt2EKMNNky9b/ZOcfDOCQQ7iksobb72rKPyk9VKeiBijRoVdqfKn?=
 =?us-ascii?Q?5CuQllNN76v7orbVHFW8fneHBdrgE/5kokgUhF0RLM9/nGlwnbscYmQvvlHP?=
 =?us-ascii?Q?9qJ/vGO0XnKYSmxrIZFN4t/AiBJPce/55lrg6bhzkQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7F71WiUDG6nP42yws+SxiHm2kBWg84hMG1BA0e7I/5ELuCc/9Gn+t2IEcryu?=
 =?us-ascii?Q?zSPRPFVZwjl261u5YZx0rFjOxvYNjkWBvljFPKFEZ1EAjN1qlbCseMypltyi?=
 =?us-ascii?Q?mYGb5vxs5bnpr0wrz10Jc6vyjV85P0LiAiAWF2K/57N+JxfzGg7LCvdb29tP?=
 =?us-ascii?Q?A9yX8bygR/rqZRH2JxQtE74QXHeth6fMBqhAlL+d9H/wVRhDliqro1tS4X1O?=
 =?us-ascii?Q?lhrRnrYJlel78MQYD5jYiapN2mQAYZmwdch3s50S5MOkNEsV5dLyFLS292iC?=
 =?us-ascii?Q?fu6OKaSV/bHIqvMoEoOXtUkXBNkft4o73uY/W9z9FwJJ9gHzs1GUTEVj+LTw?=
 =?us-ascii?Q?XPFD4dI/hs4IgJcwMf8QMTwfT7R1wkBqCn8u1FfBcsLDFa8ukHVxFC8GChZy?=
 =?us-ascii?Q?xsysayCeSkk3FmSOM4GsUpntvGpYXFlcEAZYnt8tFHUCHw3zPdrMgHKQ0ZE1?=
 =?us-ascii?Q?wbINIDNwNNwBZdw1xuEmE42IpKCeBslwHLx91oFlbRWfg/KE/wG4M3Y9/Hgh?=
 =?us-ascii?Q?yiJF8Neps4MNr+HcCd38k+0q3nXnxVijhSAbS7lHlYmwZphrqxNUqXBjIb6V?=
 =?us-ascii?Q?QMqzBeMaSPPXKC1WWWHl/pdQKTuBTkNQKdcsU0Qymj2+Hm7kkro6CUCzQdXJ?=
 =?us-ascii?Q?KZBzzbfZjCU0aSTUjE2f1ur7VnHTLceD+QDgsDOwRIMNqiJuADUWm1cGGeOF?=
 =?us-ascii?Q?vpXoBNxSIVnZSmn67gkVBMjeNccrVRUjZpbVuPiT12He4aeGrZMIFj6q73iB?=
 =?us-ascii?Q?8rz3dg2IVtGnHlO4tR6xmSeacieBjTJnp0GQf6+399Ure/FCNcqoFGiZNVe+?=
 =?us-ascii?Q?oduntq7uvwVydJKpqR8xAf/Y6NlOtjvE4mInK7PX0U1kjmNByVE+pR2fx6Pg?=
 =?us-ascii?Q?as71VsRWtHzkCQZYjr5JoNbhjI2pWEw4Vm+Ltz47lbIfAkVpNmUpVWHZzScV?=
 =?us-ascii?Q?uC6xNZ/1Yb6mud92TVfHOQn7FfIDRrLmseLRQw5TquUdN3O4p1JiRaSf/l+2?=
 =?us-ascii?Q?u7i2qcUAbNliixFhUqBQ+k95Ybsw2Mc/3iy2i7V72w89ZLjIR0Z5rEV7Tuu8?=
 =?us-ascii?Q?vqBLUufDR9x6I+YqKHuEoGog++SWrvRWUhcYsQRC1mKpscC1NycXGZ/sG+67?=
 =?us-ascii?Q?n6Z3u2YmXRbwlkY8t0rKFUtKRSsAqaPXH8Oxcvn8Yg7Np4prYEbxOMlGTSUQ?=
 =?us-ascii?Q?pW+WPQDOhmSaMtJKADd8xuw6fHCuxDoWucpLWFK+98XmpkqyUr2ljbZFTHrp?=
 =?us-ascii?Q?FsbyfyuhBt25T4JEgslhypGTd4WONynHaRMvVNIkqegZ68TQbCsckce0ZcNb?=
 =?us-ascii?Q?kfabDQvEt2NdRXhgPUIeAtKH4hPPRYPiX7ysC2fJLt0RWAnxNKeNsgl5Olz9?=
 =?us-ascii?Q?Smg2fDKCgn5mcuqOxKYICENDDwsKi/kBMYUJ1fI4fgVfjqgeXAAOED7XIWkg?=
 =?us-ascii?Q?/m2O98ehlD/4mvL8j9kVfUoxZyVpNGAMfXrenOttPPsTi+GGFCwfYeeB6vzQ?=
 =?us-ascii?Q?S6oD3BJotqzIOvAKNXvT1ozulb6YD6w9RYmQBKaDP6BiAeduLn/XjIsDYxfK?=
 =?us-ascii?Q?51rkvYHfdjhWj8twtCTmUPalMPgS1aA33SurGdYlQtskfqTOY2oeJAqEnebB?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	myHKTAJjjhLWq87FAthiWP4vQ7MuySO69DE+ACAAGnZDpSta8JS5+WOYWvYtEznTfxLFCtn12XNYpBDF3k+QBpcrznGuqDF1CN3Pa4+4S3fEzBfanKrQf5ePaAErSBTW1yku8mFZmE+canFa1kjOrbggnBaCCBpTM/9i0eY6qwQkvj5YwEWmXo7Ba6JIPiPrpeDvNdZfsax6WXJagw5hLP6r8o1JbeVFaPywTGap6rQvSkKzRgxlCDduMIKZw5HpWhK5PaPCHm+mFpqokBDEgmBtukGS4INnv6ZtMJr514yxNNg/PsYsHC8R5Y6028D9psRVjjlUMSwI3nsgoQaKTt1ZPtg0JiDXGMayn4wtg6IhxZPxCMWMTnCdu1yBHTTK8m8n0qiYcqtvy0vThXXdw1O+tQg/0XvWlWqv5DOQln3cRiXChm9rOVIigCMKj2ax7GcWwj0qX4hGlEmUECYFhx+ikxR8FljsaHVXLl7IhElDB/Ewi1HC18bDYbQCXCUYhSrd+NgYyfvQ4dpOTyZ35ZKhqRkwPNjQCSCERC+N6pF92Y2DDQ9aWHz46F0h8XZvXJXlkdDaw0l2kLFE7wK9UPDkNVF4NLJTOW1uEjZUTWg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdcdb58-68c9-4e7d-f897-08dcde985219
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 02:01:37.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KPhpA9D3wtN0e7/CgA6/2/IBb1hinGS/cNSYmjtHuk6XXubaQt+nFnB/56MmfHn5iicmnICB2TgZIgCMhlFxdKi0a06KZjw20GXK7MCdl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5694
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-26_06,2024-09-26_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=602
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409270012
X-Proofpoint-ORIG-GUID: pA-NS3XrRQU-qYMsvoRyVAAAFpHrsweM
X-Proofpoint-GUID: pA-NS3XrRQU-qYMsvoRyVAAAFpHrsweM


Christoph,

> Just to make clear I want file systems to be able to opt into
> generating PI, not get rid of the auto generation. That is actually
> kinda possible already, I just want to make it nicer.

Yep.

-- 
Martin K. Petersen	Oracle Linux Engineering
