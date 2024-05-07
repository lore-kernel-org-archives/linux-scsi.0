Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2FA5664;
	Tue,  7 May 2024 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715044837; cv=fail; b=sNCPrPdGaLyJm+msstt8JB1VUMcYlhGs6ahJzrXLeiwND/V9gYR+/UMsOwk18S5ghUHMwabHJC8oCNHXijY1UqetmxysV/Dd/EKJhxReyyySGzJzEc3ryqv9yu4uBKMBCAuBJqP5IXy3Qs9ysnd5DaedV5OERKVD7wxo2r7h97Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715044837; c=relaxed/simple;
	bh=LIcH/H3xb3IeiFeQxE1x3bpH4WRgjMi67tNdMfCGWkc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=K2Tvj7LfSx2LYhulvAyTPOyZzRzCHw3dkynlgz7C5T5TnoilMgV2voh2IsWYgqPFNJsGARJVxd5XezRKDhVd/sxQ50StqbnnTtRn34qlXBhqlrnBwKePp5cYJeGr0fHzvdMgwa6mEZrJZgYEWPvITiwi+FHiw+B5Uv7E5sIL7LU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kO7SVZZG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FfSKKtqr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kO7SVZZG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FfSKKtqr"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqOlN026445;
	Tue, 7 May 2024 01:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=0e2NIKYjnr5OC/ato0MOQ58yBYoSbG76Gnh8pKNbtZI=;
 b=kO7SVZZGL8EnlxcD1+kHRuUER2aTs2xHrKQ8XjFSoRzYRVlNHURrxYe8zDYUvcShBp4m
 VpnGryvlgqskwrilkP+NhrUxAM1ygeWWSDOh1hm7XKHe7e92rfta3rNCHFhh6pfvbbnM
 z0PBrk2wvGCdC8q/ncSv7eMJzXuY7pf9jtIh7lUDL0rMozmHkREsgkHlU7MAxDoSEPoD
 RcMFSvVHgaOiYHUItkSNeTa/4fglEk3Gv97TVuumfi2ZTyBD7AMntj7TILKjc2UvhZP3
 zpcJllyDJcgZ16rdDAvX8nvM6LGQv9Cs1G0Lyj87Gcm+KPgY2p4Ri/JR3oGmJrqMSa4T tQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbxcuw6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:20:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44700AT0007053;
	Tue, 7 May 2024 01:20:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7cjcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiSmcTglObEo4xvW9tEwvzkF+HhOBsYuqEGZaub49SGqQYyrLShid/JThxguDOcXkIcpN9HMuH0CnhDheUvnh2p3QOIW8ReZo8dV6/CnNiJrgMahrhfy9p+b49QgiIF3tDvxZYjwl4RuNNWFUgizT2V20J/rx2grSvq2uc6D+7AIzIxlPleqB/vwPJ4w2ciwy8t5zCNHujySes+4IlhI4Ube5Hgayqm9pMbX70CMbwlndnF2RGySVlKKDGBpCr2Uj/w/xLEN8UYN/V3fojL6k2YAbWkcx/fqHaUL1/uqiWVH+0znahSqculwk28DJ3kz8wGR2a3nWsLIjP4AQEKKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e2NIKYjnr5OC/ato0MOQ58yBYoSbG76Gnh8pKNbtZI=;
 b=jWxzSFBXSGAzHuthVNtP5Xwa+sI7ga3Qwj35seBKqX/rHatLJitphItvpsbqw24BH3u5YbVNhvIwK5Q0z/xUBxG5Ew3DhsXgMyEcJ8MITXluc1+hio6dp1JUsDyeIAoeWsK3Cj+e7islKmZp1EvdGvAzbshSLjhudR3SH+YDl2MZxXC78M5L91LkEXvrqsLD/4TF0QWVtBON6swZSmtaipyH3CaEYKQdK1fKxRa/G9neUkvVU+qU/If9D1fcIIptd81gay2LjOyXz/VbbAvlPK1816LoRiDkg5PxSYqD258dMDC+IKEnf297XLM6dauv6oidgRqrj4F99jXw2gpy7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e2NIKYjnr5OC/ato0MOQ58yBYoSbG76Gnh8pKNbtZI=;
 b=FfSKKtqrr5v3ZFkeZ/UdM1NFggcZlB5haSJUoPrrvCRZZMC7GamKZC19HqoKYXs4DCboxMdOMKFaT8aFKzDBYzuohXp4g7jA42LYxlmRzzkqf0aVwLTBvA8sPaS3t1OYdGqBBAM10j91uJtwujr+YMRNk9K+ZcjAa/DOCISnREE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7612.namprd10.prod.outlook.com (2603:10b6:610:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 01:20:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 01:20:10 +0000
To: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen
 <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul M Stillwell Jr
 <paul.m.stillwell.jr@intel.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Fabian Frederick <fabf@skynet.be>,
        Saurav
 Kashyap <skashyap@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <nilesh.javali@cavium.com>,
        Arun Easi
 <arun.easi@cavium.com>,
        Manish Rangankar <manish.rangankar@cavium.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter
 <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu
 Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Saurav
 Kashyap <saurav.kashyap@cavium.com>,
        linux-s390@vger.kernel.org, Jens
 Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 4/6] qedf: ensure the copied buf is NUL terminated
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240424-fix-oob-read-v2-4-f1f1b53a10f4@gmail.com> (Bui Quang
	Minh's message of "Wed, 24 Apr 2024 21:44:21 +0700")
Organization: Oracle Corporation
Message-ID: <yq1zft2xvsw.fsf@ca-mkp.ca.oracle.com>
References: <20240424-fix-oob-read-v2-0-f1f1b53a10f4@gmail.com>
	<20240424-fix-oob-read-v2-4-f1f1b53a10f4@gmail.com>
Date: Mon, 06 May 2024 21:20:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0414.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7612:EE_
X-MS-Office365-Filtering-Correlation-Id: d1724c75-4f03-44e3-0316-08dc6e33d64f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?HFlG28SLuda6/TIerOpMnfxpN6V2qGUsyBpyj5y7Q4aF0ZetMn/G4gFz6uQC?=
 =?us-ascii?Q?UdYFMLBivQBrGk617t0eYg9xIPJ32OoPSAall1ZPM9tzeFzhaOS8nooY4In/?=
 =?us-ascii?Q?bAxlf7i3YCVn/N6XsMQVUqRFRlZ6rxQvhgRnAdraTsQIy7oqPhbwwjZuApSn?=
 =?us-ascii?Q?ss+6+7Ps5Z5bv+bAafv07xGLbv5MDSvZ8ZJ6jUmkGUUDkmZVHKBYqfV7cnxC?=
 =?us-ascii?Q?L7krgX6h9oDQrHB3d8/UfghuCLa7fMOYKlOAdkrtER/2aPOhIr5I/pU9xtmC?=
 =?us-ascii?Q?kgK1UpNTZaYPAdSPkkzBdv3GQpBBfIhzxx5SLH3+vmrTIm8dVG0aMTuMadLg?=
 =?us-ascii?Q?sUgPEBs6JWxFYrp+tCHU2fMKTHH+16vnQGnoiT6dmErItQ19dBVHTW1PSJB/?=
 =?us-ascii?Q?xXsmoFwS524li3ZEisN5OKKMC1WFBnWcL0tpFIok9J1Rl9FJ8lNSt+tsxC9l?=
 =?us-ascii?Q?TryECYxA58+o94ZqF4bCNda0aGa+T4uSumVGcJcAaWHYi3dO/e/W1ouYS/RJ?=
 =?us-ascii?Q?HZE8lUgCScr/R6tfqbfT5sesx7XMleDAjqcL3RQpEAM88lupfo/1TeyIFqRJ?=
 =?us-ascii?Q?eBtxebqBaHs3Sk6RuP2xUnyC6nM2m596ZK4mueLZ4JeusBoJTRkkddQ413mI?=
 =?us-ascii?Q?8YqdVPFR6UGGunEkf7ThwlpnBxcH5l1zhZvJKggtJCI4JN1/2Kgbc9YdZ4rT?=
 =?us-ascii?Q?mkVcCidPNAcEnfLqsPF/8tSD8jF9PJzHdbFDZxUZP5EIsvdjcrlw5r0biKdN?=
 =?us-ascii?Q?CWkEyZVIiG2opfpxEBYie5RdT0Z7Pycqbl+NwZrZLXQfwG8+Gt3yz9cPCCNC?=
 =?us-ascii?Q?GejOz2NOAI1VLosi9kN1AyPUA7Bhe2sETpQtfXsdmYLM7DlGkrsTV8mEZQh4?=
 =?us-ascii?Q?bU1E8QIHFDZdhtcNWLMr+rjz6huvf5KRn5pvMKe8S6rulkI2EVh/qfcmokJm?=
 =?us-ascii?Q?1WkifB7ZDPEi5bNrKrMQPXdRy3phAAAKvTqJLmnh6RcHqEBFxC64eIhlqgFV?=
 =?us-ascii?Q?VgfA1Br26dalxh2bDL6xME/8g9rofBg8lpD6uAELCZ0SVvmIqVrAHOYCCz6a?=
 =?us-ascii?Q?KIU/ZRPmeC5sxbUT17TiRDf5CrHtkyI6swerLjvvl+N/FocUd1VyA8YVRzb7?=
 =?us-ascii?Q?oBqSkD0Eko6orPp1xroi7IEwqDyucvOEsdElcGSHmWqcczYrXXCFBlU9CADk?=
 =?us-ascii?Q?7yHP60pQhYJbJ47ffC/cfkVOlwKGFo1M/ohnpsu02XiLbP+iHYsw0rsVVv1k?=
 =?us-ascii?Q?OwejS1xK9aA2IDipQwGJWLroR8/vgtMKYLVFbXvaBQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?aNYicGVv8/ONS1jgPHgbAykUnRGM+ACDcqnxg5MDJlhj7RCnHuCeubJa5mhu?=
 =?us-ascii?Q?BD0CdxR5bt1eD2f/RjLyHl0jcVrvQGkVPsJQXLYw0yp4Q4WO475iABn8ALRP?=
 =?us-ascii?Q?FPzBW358rbV+jBhntD0+B56lk7Vzq41MfFx1SmcGZ59UmmN5HyF1+RZpFsnk?=
 =?us-ascii?Q?5M+empKBMh7e8TUh1mc3Lmxo6UunM3uqyi/dF/5roR0keNUSUn1gpZ+L6l/D?=
 =?us-ascii?Q?vigZ40qQzeblEZOc0HMnDkL0suH9m3gMruIU/NhEIr08VlSycxKvsXkAjuXS?=
 =?us-ascii?Q?/7QHHJG1ev1HidIi5+XYyN9O0TnDQItcEoLqeoohy/qJg6QxpzHEew0X1h6W?=
 =?us-ascii?Q?fHXph42LpTKZU4CvenFwuQXTnOi9RFRoM2GmlkV3RokX2XMpJaJsWBZ90YgE?=
 =?us-ascii?Q?t5SqqbZ42iUjluNCeqIYswZBEO/FUcRApPzICNhw/7lFJs/NSmVP1PrWECon?=
 =?us-ascii?Q?hv+XoJB1Q0qTDcJg8Mf7wJP/WdBL0IdjmLUbAOrnhIWCoXBSMS/ul5OUAUHK?=
 =?us-ascii?Q?BkKN4lCgL1GhNpVe09FYkJprQ1R+sg8rSq+ibnH0Ss/Hp5UyyaJwy85LLc8P?=
 =?us-ascii?Q?MlG6KnLcftjVRl86vg/Kdg8024vOMcHd4SESckpOtsiMsWndDWZ+mYm46+7D?=
 =?us-ascii?Q?pOI5deg+k/CX/Cup0f8sxUwk8OUprquL1EYF9OuouZBt7WhEIUDpDZFIqlp0?=
 =?us-ascii?Q?CiXoRpeQE1euXzRIRF4ZONvM0bukNig5OW/bf3nfO44XI8YftwpmQbcRWHaY?=
 =?us-ascii?Q?P5rZbFZvWE8LMOBwHBltIFk9HlepkpHl2y24+qDX7jAUPBZhBfLMvpF2UG7E?=
 =?us-ascii?Q?QNapklIIWtrn+eeVdbR5wSEf1JUa0TY9ShuDo07wuCaZ18kZZ7yKmZXhs/F0?=
 =?us-ascii?Q?YLc0eecTelAffEIL0mbJjfQ/pSKPojmkWiAcfetl12xi/SGMilYppqotdJcw?=
 =?us-ascii?Q?HCm6tYWEiz2e52c9cryFPmmjOZdtBhbu95ZD3cV6nRK64626Z2hnXaqHLh+W?=
 =?us-ascii?Q?rdHZBYfXSSgmL+cC/kIuMR7w+xmAyxT1jv6E3OznFZd5QVnOk8zY242RnWMc?=
 =?us-ascii?Q?10bnr26OIDRSGYYX1iAr4aYD/67K4hdrx4S1iuNIjE2raDX+q4lEx0KJJiAP?=
 =?us-ascii?Q?YvjXcMGiYYT/wOitEjMVK9jtYjk4BixkRrvvx1iSA88Spx0Mw7o3pYZ0LQoj?=
 =?us-ascii?Q?FQNmiIK2wWLsghDbzbK/FQE0Jjbk/CRg7IxHJf5hQ+4IMJvbZO9eDlD4wmjA?=
 =?us-ascii?Q?ELreXQdyBo5bUTcrPePUh2rmBTZcodfsMZglWrrjzB9c/XnCVse/pB4i2PnB?=
 =?us-ascii?Q?QAbVszbCPj1ywkEvoIbj8XmjHtIqDWyoZJMGEZZCr64EeN/fugv7dVLX4RYi?=
 =?us-ascii?Q?XZs0LPdNAIx5nRa2164A+FSZ6TSVGKJXU3JQsMkc0E4gnyjvC+nnvdJqWGQE?=
 =?us-ascii?Q?+vq56a+nr6TF5qlv0alKJF1XHZXigP3P5900+jxNMbSbmF7+Ce1CSLIV53RV?=
 =?us-ascii?Q?GOsJj5+JCxa8w1PwcEDaS282W0lNiJbxzUkscC0JkeHmTJx2gQzXH8mIqJ4b?=
 =?us-ascii?Q?EaVDJ/3x/K7PSLG50XLfIZecPjJUWJR8pehuyqsNz+AriLNIAD+yUY9E9+hT?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cGImfEU6d/Jv31pwO+o3SwBupsVqZ6KZhsGPDLZEKTBPFYrBjGzihg9SvZ3fj+aGqYay2eaRdRtLl8+lDzIX8bFzqjFs3UXJM1gyadbbmPiyNDy0IBev9kJg2YhsveH4kzKmkZMtl8c5ZBCK7XAWR5o9yqXtDVN6UyjNWjBp68+UPCBAXotJAW6cOIirRJxUx2uoFsqSJw2O+Kc3yyILjXTD9biG/EGl9HwFAjdliEwQlwnQgZFMD5mYfBkcnofMEE3XtOpPJZ68R5WB6oKcUq7ofQBn8KpS9WH8C3/OS0qJSJYqzYIa7wZYH7yD34CGryhMFguEb+FlM6cbkB4Cpf8YqWk5zuUREKHoELGDMS+1ROEXJQwqqNjY6/TjOAYsn9EFA0iPRRuLttfANp9TAkiTBYCiFNgjIzIiAsaDv5gIIiYpNgpvxiv1hjnuYddkU1tLHq7iTAx34w/E0CejZxquGs2FAvm2KwsXrJqgulPzxA5Dw7BYGL9MKlZ9xLdy58OSUtPGXLZB/FjqZeQaoajHfEGOsO9czalb+Oxk2ohyFI2J5RUmR389kneclXHYd7z4+zl4+leoNIzIzpQE3VS2vmt00JXHaCrY4TzI6Mo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1724c75-4f03-44e3-0316-08dc6e33d64f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 01:20:10.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f80z5UXqAKe0/5M4OzeObBziN/zB2I7aDwJo7S1zArQcZrKdvTkgwSKxBBpMdpiSL+ZeyPaS3mMTWEnmW16ehCnsBmrUQptKhAzJFfLFY1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070009
X-Proofpoint-GUID: 1zG4D5FaTvZiev7CUuwWF1edgCqA_PMw
X-Proofpoint-ORIG-GUID: 1zG4D5FaTvZiev7CUuwWF1edgCqA_PMw


Bui,

> Currently, we allocate a count-sized kernel buffer and copy count from
> userspace to that buffer. Later, we use kstrtouint on this buffer but we
> don't ensure that the string is terminated inside the buffer, this can
> lead to OOB read when using kstrtouint. Fix this issue by using
> memdup_user_nul instead of memdup_user.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
