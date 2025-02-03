Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E07202C4A;
	Mon,  3 Feb 2025 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738623719; cv=fail; b=eGZ61nkOHHw/uGZaJVn+aBZFmBugXJ4RouwRvrlWoNJqynF4d/4iHXqbGGxtSvGmmCD45OCy9wULV0O8l/pNvZt3umzkYoIC3oZUD3O6KbZyR/+WhB8sSPx6NAZJ7am3GBSx4wBmtaneFqKTZwnsOaOy6ecKzfOvhAVA0PZwa54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738623719; c=relaxed/simple;
	bh=ISRdmCZNL/tuzW3df4u9qakTdmvqdkcWW7D2i9Bjo3o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bY8QWVbNnpviEixmGhRRxqqjGGDqBpLUA7O20EXehWeq5MxEVIoyAqwhBSuHOeSUYqwU7IpxsmJK6yCD3myxi6yW/7NlPvSSxY0+SUvPdAUqp/cESV5KBriQFY9lcq1VJNZBWUso53vsvCsWsdnfWF+K5q+cKRzxK6nqFNpCwnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bs3r79WR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sWA4jXPK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bs3r79WR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sWA4jXPK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMr4A004430;
	Mon, 3 Feb 2025 23:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=tGesSGnCyAUey8ec7M
	lTa4cjzYRzDatYMu5AaDoAP48=; b=Bs3r79WRmY4+0wG5u27hA5bXVIh5xW1z9O
	hYQtqy6z9twAPxMzytFG5Y4KZLDXnLaX/ui+KZcvmbX+p646ca3eTcYoRq46CKD3
	Ank2QKRCOYzb3IC1so86C1VOoxNvNRhKsMEFUqVEUNw7WtDyOafrXlpwJKkAZEQ8
	cn7CEXVBBbEEhrzE5ud5OH2k9QEBUjRrY2uDX5HAjCK/nFYFIJ4VBRvOFmlOEW7F
	5hyjz7wuvsEa6lI2KxaAc30K23tNmPgNpDZNl8I6Uua4WOZQ4bHxgSnSbRrJFGZL
	rVLAijmByrWHnuv6GNcV/ji4qeERKPYwh0215P8dmogqeO8EPJSQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73kmm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 23:00:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513LbdQZ038932;
	Mon, 3 Feb 2025 23:00:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e70nfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 23:00:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3UFOVo2wOH0LPrA8Qe3GQnyeWKWktg8c1l+wGBr/mhre/KneQaPzwhg1utXw3l5jhGtQGD47Azh5WTx2q6Evq2gmTmqbtXiXdNlQU/Q+pUwBnqu1HaTlV2JDHcF1nw2FrtzJZaR99m1+ef22w2iVOmIErqS0GL9/Bd+Utgm8TxPVaAWaGePSj48czInURgabrlaH9lVYToIUM2pVklLkVvrIreQ1a9iPZkOmJO0g8hd3ugDHWqvBPwEdxjK5zDP5j+pXqPbSfsjoTD66ak520xjR2lNe1Y5WX0OAz+0k+nikukGwNUrUHdYZf8ErvHaeNjwFjvweU5ZY90uH3ys+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGesSGnCyAUey8ec7MlTa4cjzYRzDatYMu5AaDoAP48=;
 b=g2yi81SVOH7k3BluL2lh1DfWbo/8cSkee5C4UHCIcqBkYxwiOx6VGPnNd1tz5xov1mw+lPQMCqRSydIU+b+h/bLMCzn+MforvsCgTHyPx+ea+OGQMWRBKprmWT2KuCWv813yE5SAzr2ODoHexOGq3t57Isd5xpcfUtiOZSaek56rzdsUvc6hbk4q/tutN6lrQUSkvC+NStGM8njUZGMCOROvNIjf4GimtWARgPtu522kG8Er318/mNAgXPMy/O5C6tmhNRQzl7iiOD8KwTEhZtLfknQ1HnmvRl5f2B+EQsOREWS4q3GRhI5V/IrOaYqxK7/FzlPSOdZ4kaOEiGVVgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGesSGnCyAUey8ec7MlTa4cjzYRzDatYMu5AaDoAP48=;
 b=sWA4jXPKTqKWumK4fUt/BhNGJ9n+W0dbqPfn5aeoKKmpE84Phq0LtysHNmB+8x9UTqXy/k47/PNVIaoTaZic/z1+nNKc7PfSXvD4SnRbWde3Kpt+2i5kBElkZkrierShFYUD1UdJVxEZLfmJhCLlV9TIqVotsWGSnGRrBwHeo+4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5182.namprd10.prod.outlook.com (2603:10b6:5:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Mon, 3 Feb
 2025 23:00:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 23:00:47 +0000
To: linux@treblig.org
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Remove unused config functions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250127002851.113711-1-linux@treblig.org> (linux@treblig.org's
	message of "Mon, 27 Jan 2025 00:28:51 +0000")
Organization: Oracle Corporation
Message-ID: <yq14j1ahbwf.fsf@ca-mkp.ca.oracle.com>
References: <20250127002851.113711-1-linux@treblig.org>
Date: Mon, 03 Feb 2025 18:00:46 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:408:143::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5182:EE_
X-MS-Office365-Filtering-Correlation-Id: 36017c37-3861-417b-0719-08dd44a698b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AKgk770mVLqPcJ69rGe78eWv4+grWiWIe/HUIEbvIwVvblygETg2VWBWgAtt?=
 =?us-ascii?Q?OwHqVAzm8IRc5ZdGG2hzz4QPCfpyjvNAlrVymrh4J7KZOegwACiG8RkeLdnd?=
 =?us-ascii?Q?5g6i9xYnUzyF52nfxmAXG7v80DMXv8Ycqzr6OCf6TqyoRltUgzZ+BEe1TC90?=
 =?us-ascii?Q?KO7T78Qq2Ii2BZu2edeFuobKTayx9oKs6pv5owL417CT1Lu0Qvg+viGI+iKk?=
 =?us-ascii?Q?S+B4XZ/GxS1hQ8ccXJrLXHkRS1x0zgaqlRTVeW+O+lcSYhJOUAFqMeE4Etke?=
 =?us-ascii?Q?Eq1NQWe12Lj0SORvE8e8JSUIXem/4MXf396tYxYjqfHdS4n9FmAGpBa+HfHS?=
 =?us-ascii?Q?uN9g9OWXNGopcnZgWi+MuKvHJ9UozkyqmgCF9TAbYu4KIMPAm9NRYX9pDWKK?=
 =?us-ascii?Q?YOe7JiUSgwrOL3VDUABpZRGnXCcXTuoNlzi6cVNBHM2u23B71DF8suj9jgON?=
 =?us-ascii?Q?uEVu7sv5uhRqIVxsbL3x4AvynqSqA7IzBJXP6lY7e+EMUmk7H5v/UZ404axr?=
 =?us-ascii?Q?LPwd8rfZ/DsCu+WQC+XWEZl2CNxo0igdx7rnbQtXnC6cAGYN7i0FpdlYGvkA?=
 =?us-ascii?Q?gUDadTh1YK8FteYSRra2sycSKi98PVpBw+bQFVRBvYtD9fKBQ12jYWayC8D1?=
 =?us-ascii?Q?lrJ/SFloAla90pTxTJ5HD8EB5QSC5BpaO5ZNkQJZfsw1iUzRGBTUF53wR80i?=
 =?us-ascii?Q?eFrr7JPidpZc+YUpY7sEAfk3G2jT9kKPetvbhmv4C+8l+EgzDVv+wzgHC8G6?=
 =?us-ascii?Q?HWNS7JA/htwrpIEDhRTbWkQDmSywczZE/yd6In7EPgqKMzNHd3RoOwCxa1vA?=
 =?us-ascii?Q?AI6HNuQkiAd67Cb/v98ughd1Gtd/g2cO4HS74Aqha5L5+J3QWZdbeyIja5I9?=
 =?us-ascii?Q?jkzVYYs3lAshRgEQleS078tZzbyKVkgl7snD3pORFiAQpTn1NRnGiOlH/krZ?=
 =?us-ascii?Q?GnEw5L//zwcAGr7dJItwICUiR2HTP+lRl3SKAB95Zu0aMd90tzfTXn8APhIL?=
 =?us-ascii?Q?taz4y96BpsSMYZNnRUrG3KK3HWlf6cBw/rfeBAPfLS/fE5G3lx9QWXwgJbiE?=
 =?us-ascii?Q?HsU0Y9dU7Qy/MB2GyadBCne0WIKhH+K9SzRDRZtYUCQuYlaMmg9JcezIK2Ay?=
 =?us-ascii?Q?hondN1WplEVC2zSkNKDNy/DfOiiWZtQTg4TGhExYhdjBa2OHvm34Nlbht2t7?=
 =?us-ascii?Q?mIoZ6sw8CemCGHVgBTihiEUY4oK0A4UrUEmXDn5Ho7/lb+lOH1eaqft/+fES?=
 =?us-ascii?Q?IcgU7ztm1UETDk5Uve5sZ6+Uh4qfLPtLFRUh7dqgCejo0iUmZ0Qr4hG/JZNy?=
 =?us-ascii?Q?OOdhsggLkg4rDs8bU2e8pVNvmm/e9jOejI8gCnDUVN1zxPdoS7EpyqnpE5pR?=
 =?us-ascii?Q?r4Jd4oRoPnMSSHiKbbQAADH0KbWh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LLqqKrO2toskQ7Pkm69ewSD3CO9Cl6Mes6b9INphx9KBVb+PqvVfztVoVOdg?=
 =?us-ascii?Q?WzHuD8i17Vn8/btlVXEjWa/uWt9Fd685ZJyIaObJ0cnsb43S4wkEB7257wPH?=
 =?us-ascii?Q?T8YpLzlr4m7WHCjUEu5RTi3wayF4Eaz0JHYGcVOHkdwG5fMX/WNDy8WQz0CO?=
 =?us-ascii?Q?xyeS2LP89A0b79S8vCT1gBtef9hyYpra3CGCAHRHC4+TAamAPeGgEWU94TUk?=
 =?us-ascii?Q?L9EinhlKaH8+uuvE/5BoUPpFV88zdeDGDsu6LryBw3ckrDTgbRhrohjEFDYI?=
 =?us-ascii?Q?fupAliK1GCqF2XqLn5fHvEknEmvkORPm+CLK+HH5ghpmnw3YfxV14RjcjrvA?=
 =?us-ascii?Q?UANq04qn5Y7GRwYSlpxO41OLWM9TKOuBrbioQ31VobqIjgAChrkHvHLXFR0y?=
 =?us-ascii?Q?ewuqCpW+yHCxpz/I2hp/+BNyLFkInf508K1PzKfXFYHWhgZQNSskaLxdDrM5?=
 =?us-ascii?Q?t26FGvM7Yq2T9iEKKoTZIOqKah1CR4tJAVYILRvFh1DSOXK9x+KtMaZuNo8b?=
 =?us-ascii?Q?EVDYDRoFASXHfOw6WSdxxB1pmchGZ8ZJWmJ9elIC/a6mGjW738rVZ1QICdbi?=
 =?us-ascii?Q?6IFzgXPr6Caq3FLrqwSoXCVjTGpnBzOeY5adl1ANe0IBxVL9fdUbA3/4gM13?=
 =?us-ascii?Q?Pd8BmF1dQyJvpOsPkdSKaMdAfiV48yJfYYq1iNd1iuQlC8/ZnHVXlo9uYtp5?=
 =?us-ascii?Q?Y+IkIBr//isY2UQbO+fS14lfhNWM+0qYRLHzKbL98hhtn8kFi6t6CFLt+siX?=
 =?us-ascii?Q?w4WCy3SPqvTn0Np+1U0uUfkG4WonkEehGOtVkYFAj1635npd4HtRywTuwd1k?=
 =?us-ascii?Q?j1mwsZRPSl8hORkcOLGd+rwtFZJlN8K9/zjAMMan1HP3SnUuubsjENESyVW5?=
 =?us-ascii?Q?HXG9U2Fy7CSZFKdd0HVnK2gwq7T38ncVuxOm2b+EY2HMTZ1uSD00g7eJStE2?=
 =?us-ascii?Q?sahWjgYCbY6s89xYypVydTKn/nYx80osenKznbJEblZ/fxXEMzt9gSUDjxVF?=
 =?us-ascii?Q?c4RRXv+2/FuVMzScVmkecW4hzbd3Qgx0Cyw/+izMnoq0CekJILULQ7jZzS/1?=
 =?us-ascii?Q?CZI32IswcDekJEIsEdcgYh4cUaGQrGy/jUN4j8gEJ6E806SKpC7GR660W3/o?=
 =?us-ascii?Q?fOEtVkptiSppGl7n/8oFMCoJgEXOx8ExFHqwLEtZtF18mZNGrqOB13k0r9Ya?=
 =?us-ascii?Q?BR1JViPDOVa+VE82wOzba4uV8F47hg7HlhsgcGx5igyzJJI5ck6ZOMrfDeFb?=
 =?us-ascii?Q?q5jBExVa3+9wm/HT3W0eiHBDxBewI0mBhjvQuYVAbRXMIida1YYQmUhw8mHx?=
 =?us-ascii?Q?6Bdxzl+2w2eJacr5Wdutlg3LXN7O6W4phCRjY+nYAgXsRX0Kj6nhFB9Hd7qN?=
 =?us-ascii?Q?hVi/CuxXohGbcExzW2mJy9mGoTMbYdH5+gcDlRmQtPQYgI5+bncwV+9hnurT?=
 =?us-ascii?Q?YcB5a+zA0k/6D+75jZyYLnFnUTbk7QQ+h8Ucr1oAthIWBRja8COsMfv/HQur?=
 =?us-ascii?Q?DwYbkVzY/ynAo0EHpuaOL5AxuSGiQWu6MfRmC3iRbmWnmsw/ezRw3eyYWGG5?=
 =?us-ascii?Q?TbQd7SEN1hlfiMLYUnJY0L/FhBqMH+4z+cNmHFHuFzsOw0rd3Cu+UPH9aLlC?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j16RmAwcvavqG7AIH3BuVTDiRLrR1uaeGkX0TQjeiNp3wTQXUdyaAo6Lyp0gOLtqhIIS9vtisTdaFgi27oL+jLNhKLQhqtKFcOL7tuRc7huJvdj7TK3tbRrhci/dwH5Pml0YOdMB/+6tdIzcewxaWPPVFTrJJHs6lOel80FsXvUCv6cp6X0XwOMXwPtybBefoz3j0B6FpkddRvnHABVHS9CAhugQHVzLaD4YXbgrNC/bkyPThXba6A4CRkzY4RZlmFxPrdcYLcS3DhGkyuoLYeMrFlEwfJsnAX6cZgR/kwuj11X2I/DPMOjpE9l+vxY127o0/Abw7JXZuAHEYZGnmWBYOg3NGwXLv5AqiTVkkjr2oRv1zWU4VHEylXw1oR4tSyXlTo7rWycpbb8Zaqv9cHzfNtidSKmB/0u+opAKzgMNiWqeWyRiCOrYy/7o4QShwup0ye87p21e+CyNS9VCz5FFA22RGYpOdL58JzgBtt0Tv9YxRZMNkU9aHtJ5LUKutIBp5ZsNpkF9vjML3sTYG64VfRcTo7peWtcdwbxF3w/71UnTqXisgXF6HOxvy9Xx4906ov5Ly0p+B7luBF28NT27sidwV4trjUzKC01mixs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36017c37-3861-417b-0719-08dd44a698b1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 23:00:47.4555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YaRjZqjjvDtzTUGeYGV+Uu3fBkjx9ts8G4IQ3FBc86GGUGTyLo+yTtfPPiU4GY9pjd/J4e2RDzaq5Gsictzk/QrYX21ByrgV4mB3kQGUNyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_10,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=909
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502030168
X-Proofpoint-ORIG-GUID: 7pNRWMf5LHvBsYKg8eOx5ycyUGxFKfPc
X-Proofpoint-GUID: 7pNRWMf5LHvBsYKg8eOx5ycyUGxFKfPc


> mpt3sas_config_get_manufacturing_pg7() and
> mpt3sas_config_get_sas_device_pg1() were added as part of 2012's
> commit f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
> but haven't been used.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
