Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C77C1A23AC;
	Sat,  8 Nov 2025 18:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762626521; cv=fail; b=aoH2tOKmrhve+m5EgKTMBTIVRBKD7Z0DOYDpUXpu3AGh/BH8tGgY2UGKxBjrPQegH/qVilGZ8K8Bd1P8NLT40LD1zia3ejuWatEJz6TgkO1HLKiafhaKynM3qdZSEvowuvfElg/zHxFqQ6+ecvdi38qXLqB6Tq50hW909VJT3kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762626521; c=relaxed/simple;
	bh=XiVjPKxa+VzYgH1oylsHikxKXMqcqGakxNgfrfzpdzc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=c0G678niKGtkwBvzOLnXrvEMhsPIV0CbsjI87wxf9NAjhdOYLXAhlFcrFtjfqDnch/UnVsKkCThBTrPJD9oAQUwwksiw0jlROWyXxLX7Y8uolQewa+hMdsoLevEuuofabeu3Vj/Mwdn4+x2WTU2CDmDoChvo22HWCC5muLTkgH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X8GP1IPF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hsd9Qc/q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X8GP1IPF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hsd9Qc/q"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HXsWN015840;
	Sat, 8 Nov 2025 18:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0t8sQ8Qy/wUI63YIiI
	Xp+8EFNdYPy4SDEKtaRTG8xGw=; b=X8GP1IPFrbC2Km4mcm/juYK0az50EsZjPz
	OyeDC8P/GMJvdhtcQII1QcGLJYEfp7gFYnBgdvJZLvSQl6qRlvmeAl77zW+xHNxO
	9heriNxBu+sNKX71XKSpwbha7EEAR3BVAA1W74K/m0lWXUP0zfmSciGoqK/52Yrs
	a6IoYzQDIVGejQYoYApv2sZd89vSGrtOuaIFFPOy7u0De4bELFkc7tMrl2BtYpTq
	Yhw26RUuiQsev8bd7Ll8V2Nb2o2Pf5KBzYm6yAIj7ZSje6n96XItVCUS/r6a72z0
	034MiOrs6IEv8gkMs7fqgB15wbQEvzmU9AmG1144+6GgaggzobPg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa9k8g2c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:28:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HGDwZ000889;
	Sat, 8 Nov 2025 18:28:28 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011028.outbound.protection.outlook.com [52.101.62.28])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaaqr07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OxeRBOKLPRY8tyQLUUzv9rHxWCg6do2A7n02eoBbb93I/YQWaucSbH7Jb+EHpDvUGb67G/cNlg4U9+wDFOLj9zxl4HpsiFXECKDUoo5kysvc4cI457qrc9zTYkyZivEu9gVPVjaG4K/pjKi0T6ArFZGMO0I8utTKMyHh/Fab5iQmcHZo4Bbb6AfobLw9ht/Lg+0ve05ZwnCXn3GAV5T6bk/VlgsiAOWK/EgMlPwz+3lQhKdR34KjHZNtMDq666n0dqWbtvdB8h9vXMjuGBnLEOSM67x/W2CQmNhKJ7N8W2gQX1mhM5GYI/9CXY9sotS4hc1xwnMhoKGdJgQ3S5itAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0t8sQ8Qy/wUI63YIiIXp+8EFNdYPy4SDEKtaRTG8xGw=;
 b=Stz4iVUtMlHrQ7J5S8flHP30jG/0a7qDOufA8vnwZWemIhpOnLRqhZQLzTe/DV8NV/mkeK4iBCwa8uao9RjyJURo9O4+B9FMZSXaZMRhVxUhgFMQ2yTSYXuekSe3iaLTmevBm2lrS5FA16MR1/T87uwiW4mg8MJKHKoGWwB9ZCdKo0e2CDshD2CVJhjHAiJMobFUBRVcC59yzkQkhMcTvf9RVDA3L1seF/zuQ1Qzm7k9u4NGYNFO+ItCEda4YtrXhtJ7263sFjJaxRX10MuBSDIIWbtQPN87VxmHgnjKB/M/QoqMBzJBpyFlQsSGXPWCe8ONxYGIZ9170Q78a1MBIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0t8sQ8Qy/wUI63YIiIXp+8EFNdYPy4SDEKtaRTG8xGw=;
 b=Hsd9Qc/qdw3v6KDyyuUj3bgCr+emh/uzdVcC0is7IoGHHZVgP4erkk+eMx8rURvDO8NSe4eAVrng7p8+1AIg9BXjvF6BHv6+t1EPfmzLkuMaUOa9m0y4fWl2piicrjfHFrZsgyj/xFcI6sJHnQeIo5ZTiFPDaGOKmKbFSQgI8Kk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7016.namprd10.prod.outlook.com (2603:10b6:a03:4cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 18:28:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 18:28:25 +0000
To: Niklas Cassel <cassel@kernel.org>
Cc: Markus Probst <markus.probst@posteo.de>,
        Damien Le Moal
 <dlemoal@kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] Support power resources defined in acpi on ata
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aQ2zI9tIb5asD16k@ryzen> (Niklas Cassel's message of "Fri, 7 Nov
	2025 09:51:47 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldkggz1s.fsf@ca-mkp.ca.oracle.com>
References: <20251104142413.322347-1-markus.probst@posteo.de>
	<aQ2zI9tIb5asD16k@ryzen>
Date: Sat, 08 Nov 2025 13:28:23 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0178.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: c191ae2a-33fc-4dbc-6f65-08de1ef49b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D+yOPxrKprS3BYKUKmAW3h8nvyoOdvqU5q/utsnTOVueSflLwhUuZpWLurGI?=
 =?us-ascii?Q?bEKJHTJ1/GVXwk0QsGmgePMLbfE0FBQJVh917Y53+2qPJ3BkgLL5khuKx91U?=
 =?us-ascii?Q?1OcE1VAkZHv5uApMmaLbfmHF19nDUTSKcKznVfffjJHAct9/ASO3j+aIQIxw?=
 =?us-ascii?Q?memoizt+4u2wY/TiLCmufbUfEY//PlmeSVCNeuDzBDYhutDyWb4iJ6sPoXBP?=
 =?us-ascii?Q?jGV9ApaMB2DxmkdMfy/mLOCSHVol41mnEuVSmV78O63NT1zqaYs6+dmS29EM?=
 =?us-ascii?Q?6m4wvFJOyvhN0oSxa9sb+76CkQJoFdzcvAEIIf8pCFTDM8+ltpNmDNvySA7E?=
 =?us-ascii?Q?2ziSqOGBPWUKhyPgMswr/8C+Dr3VFBAtgcuWrXRl2+DqkKw7zQMygKYa2taH?=
 =?us-ascii?Q?Y8q+ocA3GNOQueqP+vueCDcw20dMLmNQQWMNPa2HYbSMDCdclHgA+j+EOUME?=
 =?us-ascii?Q?mQeQMorak3+aUEGmlv0aaLqk/wnz57KAMZvA0mZL7bdgrbU5HywubMQU4yG9?=
 =?us-ascii?Q?qhDRBPlxSKHZStSiVE+C/lcC0026GrbWgIdITwc0tPxsW6v6g7S2o+vP5TQz?=
 =?us-ascii?Q?9efY/sx4CN41QAp0x0v3nc/PzgI6v5SUN4mF9CvyDkC5CHxNwVbwNxp09731?=
 =?us-ascii?Q?oiWI8rrXzHexZQXCKDYn9q55nr27dbTUzW8jxp0aT05QAJVBB0f6louryhKF?=
 =?us-ascii?Q?DpuPZZ8oPsBV7oGjSPTeMAyC+ftk28WywMV9yZNeTMD+WtRrliq7xKre/Hiq?=
 =?us-ascii?Q?L8qPAT67YLNX3rpY22riJEaMGgqBuvmuLlPa/5ooNAJvFXqUWxcGxoBiqFQn?=
 =?us-ascii?Q?s+ygUJsWMKxva4oHSfnk7097JWjwr76wJphFqOsJZ1M/pUkE8Wc9M4b+qQ30?=
 =?us-ascii?Q?TIsIXHogvRpb74bGSVau3bxW5jfPyq4CmobEYN1FiguL8Z+IuLATrp5YK0JI?=
 =?us-ascii?Q?IGVniZbhTyPviHe9HYyLnjUlULnXGsoXpU6/3IhAD4OQ2OJCuUNKOthOdOHq?=
 =?us-ascii?Q?8RXUoY6rIUPi4OLw1Gub0o58silZ0LJ6ldv52xdlARmZF9qoxDfjMTTz7z0J?=
 =?us-ascii?Q?yh0q+IwySdBEqZBXFmw+xfuuXF4KdXpxnJLmf5d6E2XQWtHYxwlaV/EQRij4?=
 =?us-ascii?Q?9ktflEdXecbmwG/Bq+N1lwOxoIHR20KSxh22kx2c1VMhVVPpYx0jrOGHrDx2?=
 =?us-ascii?Q?bvaVyXvcHqQaA90MZXjZFxqniUrBVvqkMmZ6MO2AO4M4ZZFEiiYiM59kkmAS?=
 =?us-ascii?Q?ZOibNVbjW2J83CHtVKf8HXU9AhskmbRWj88O4Miylc6xGUSdrTl1pWUsOhZr?=
 =?us-ascii?Q?HSM8kDfOZ0YWhSeoTvxlg/uwe6+LXj3YqTuydMZ5W5ARFNWIvsLU90bv+/EO?=
 =?us-ascii?Q?bC00dkraeCjynETcprWOr2dh64eM2kKuQuHKCTZKI2eHPwR2vo44ZPMNPKXi?=
 =?us-ascii?Q?6LpfE2KNGQrUaXu7zie+PEqUYxVqc0p5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tJnxsAk78FxshDv1d+bCWvRXP1YY1GeOkIiJyG8bX2e5M/IO9jRa4DnL0Hl4?=
 =?us-ascii?Q?JYqjY4NBnk111Qs8NphA4YOXa3ucacYNuRSABjFmRA2iMJz7E7o99FsKgx6A?=
 =?us-ascii?Q?Frg0ezmoVukVXi6JkW/xR+wrG4HM7mh18xXU9HHW1w6u7DUeWkNN5BWIJXkN?=
 =?us-ascii?Q?g+VTbgJjthCOU4x6Bwzistw9I2SiPMVnaoyF0/nRIMpAG1e6TxgQQxUu+k9v?=
 =?us-ascii?Q?GCoY93daTHUAQZ3KVmyIllpPFVC/s+BIFlaDQ+4qMJMfthOC/mwmp8zvgk4Q?=
 =?us-ascii?Q?wt994tc40h1Z386fT2bZjXkYgykJ1Davc5uL+COBp+fKmGmQCXDoWgiTVinz?=
 =?us-ascii?Q?+PysjFSwuJbiKQTb910aTNaYHYHdJSjzcb61ueOFMSh+nZJqrly46BdxXwqI?=
 =?us-ascii?Q?FDlnMNxEKBs70R4NG51QqMFNyOQc5MTsmywKjYNcOs9KTe9m3q9SpR+ldagl?=
 =?us-ascii?Q?sV6ADq4cLOLVibcY1xDpITJMkK3BgswwcQ9u2DriNWWmzUPhW6oQEhCl8A4U?=
 =?us-ascii?Q?s07oYp6yJvTGn+MpanPTQlbA08wXYHzSHhN5HLL68ycT8+qNCr71AAZk6h7T?=
 =?us-ascii?Q?Fs260Mf4rpxF+d9TGkTtpMngAO5JgJYtOQj2CBLiXCzM7r+LmH3Fbb/YYf9I?=
 =?us-ascii?Q?4pYPytt6TxhWmtkcSit9ev12/fB8ES91aI0xQCxPmIv2FKBJ2bSzw+Jk4cFm?=
 =?us-ascii?Q?xYjenwlSuUs61EflTQwMlaqC2HQft2b81XUOgxBv8fiMDBOby9o7HjinFoze?=
 =?us-ascii?Q?HRjM1rmh+Yqk0M/sjEWjETLQSrySaM+TI5jmdmR050PunuY45twE1RF/Tcqu?=
 =?us-ascii?Q?SdyXVa9bWYYwN1M5kKdKMo8v7JoIUaMQLzsqNGuzLv2cla0n7MTihzg22Y8C?=
 =?us-ascii?Q?cz7oUi7tUGQLRd/EqRFtXAqY1sV7hvctW03GEQ27bgqva0J4mGY0I54XIZnf?=
 =?us-ascii?Q?xItoSKJ7fdAyDRr8FnNzwPnJOUYjDEI0nsEqvpQi+6ZI0Ad1CJ3oYE53IUgE?=
 =?us-ascii?Q?FBLu/5p32SXywEob+H9oJwrNMmu+BfjgJzOfqLb9H02XHoVI2mYHS1aLHBX6?=
 =?us-ascii?Q?NwLgmWxb1h2/73NhMbRLLn/UtWF7Htrl1m6J4TTC1ARX+EL/Qmy+dIMzShAf?=
 =?us-ascii?Q?BHBwtDfxUBgYKiVkjXgAaCR5Csd+suZpuUTIoA56UVu0Xp+8WXwP3s8SVJ47?=
 =?us-ascii?Q?L4wGBQWjPO8yHNSCEzdXQ7wm5TQIVUmYuU9KYDLyn3vJmhbVljU8BS9/xAFu?=
 =?us-ascii?Q?0zq1qPNusa/pjcBnBcZDCJ5CD2lmPY62J6ABsFGcv/bKW2F8zinxA3051j0g?=
 =?us-ascii?Q?+oNASdFG7fI5RwRBkVR2gSUxxhT8IPx+20QrtSTD4hQYeLzAMKip5e8FafHc?=
 =?us-ascii?Q?xw/kCMbYxVWmdDhZaCRVbxO5pZQsqRDumPvutuLw1bIITlAEIwxTkATlVDPx?=
 =?us-ascii?Q?lbIUkZRnZtjVxZifLsEZytcxtu2kceN516GbSHQ6YqyNK7FujPZKnJ+R/fzt?=
 =?us-ascii?Q?vOYmER3Aa05PNDk8uPB193X1FjHcYOEBWGEvhzdwwAvAG6A/OczujglU16hv?=
 =?us-ascii?Q?o7x0DM0qtrhkGzCKKWbsQNaGIAQtAkfutN/KXRw+ncpQ8wHes2vKYDDONWQF?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FE61VHRIS+Ek1r9AoP4wysPq1Ac4wTgpgf4SWsv40gKOuSmZgI012U0shvUDKgIWc6mMwe8RIvlpTg/FAOWfF7zZ1fjvYX3t+ZuBkEnYty8VOwnLAQMhIOhFEPAIzrjPRjBopI4zp8S+heIHofsqUKEDpDXbytFHmRpb7ktteepgCqBCGIU5bY0sqZKe/fKLYNMgxve8h+eBhygB5c2Jc+xFcdpoGERGxa1fflut1pMmoFzOXtSRpzzU9Jyo4Xw16PB6XuZfJ6lZoQEWnT5+Xua7eWQt68FSDuiyhJmCK+BAFcnqPDDSuM6DsXS91hhxKZ6Cvw5a7HMmCtP8i0P8tkG0VMiBXSGHV26o8vLl0d5F/DcL0zvgiUMHn8QHy5h6CxDL9fSBnQNLCt3cscNC+bwYHNdoUrfl5yH/JQqV926RV7cnudGPGwfK85EIDdIvc4MlO+7IrBygnikT6RvZJ+9tYGh+iODIH6qY4L0UbdmECm+DSbx/w08PmeOCXr4btXjVcy5uXmsryECyWRLQd5mjuMDz4sG67FjRqmZOTSsNp1YfzudYP5Fw2TsnyuYB5w25VKAYssfYPtnlt+TlEFXxGh435eGcX12vLhT8SVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c191ae2a-33fc-4dbc-6f65-08de1ef49b09
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 18:28:25.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRcUZN8ldN/c7uTNSlLi1uckelrqZctQmqKEQFNEZJALfCLJ8+24RRhGfApgT0Pwb4CfoXk/+7prwbYl3QTqGBS0hBYTcVJzhq9sjJmRFWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511080150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEzNCBTYWx0ZWRfX/djTRtH7Yldb
 PqYnfrocs2YQcDjCj6b/JOSUEt67/0OnWMCsOWXgxwo9c6gqclyit8+iey9Wlj6I0xqEV4ZdwMc
 CBBqm6bFtdliTFvCcPjyvYvvLPKcfsdX/zS17mo7GvAIODGzXPYYg+lyT7V+naSFtkzOKI051Es
 9LnJLenrI3+H1KwOqHkLzruXBEoT8937fphiqqwj1v3an3EX8llKT3wPSSy1u9gkVdS6vhsqv/d
 iW1c32pvLd6/XtiB2ikFtQZg7ITfNT0RzcCtabtW4cX08eZmODdPVwUgkCRkDWRI8lApMRTIlqb
 77Xk3i2tZsPWrzIKbK3OQWQf/qsbRtYpMm7LH4FY85YYt7pGy0KEtvq+CIrr/iyarUvfdU3BngP
 GMITNd47xCI0V1dd5FOKSJLW6r7hIP0CalCm0qF8S83vM5pSw+Y=
X-Proofpoint-ORIG-GUID: I5iqgOHRUpnNHiBaeB1s2--Py78PevmE
X-Authority-Analysis: v=2.4 cv=U4ufzOru c=1 sm=1 tr=0 ts=690f8bcd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=O94LlKD3b0cR87-nwmYA:9 cc=ntf
 awl=host:13629
X-Proofpoint-GUID: I5iqgOHRUpnNHiBaeB1s2--Py78PevmE


Niklas,

> If you have no comments, is it okay to take this via the libata tree,
> or do you prefer to merge the series via the scsi tree?

It all seemed pretty straightforward and given Damien's reviews I
applied this to SCSI. If that creates any merge conflicts for you, let
me know...

-- 
Martin K. Petersen
