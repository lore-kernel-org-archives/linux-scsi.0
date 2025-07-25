Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42332632;
	Fri, 25 Jul 2025 01:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408711; cv=fail; b=YzxHItWK9t7O6EpgrmbAabK7CnR1gVl6j+kQ4cujSQ7CWUXD0Ja4OhjYSs+YK/sd3Ef4kADZI8UtidJhs2NdAeOc4v3g1kssM3Bj4SRDSJsNHvFj3a2a3v/L7m2JEyMup23RWxbJH+P3sxJBtLIm9BmVq7sb5dHQ3VUugSYCn9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408711; c=relaxed/simple;
	bh=hVIdym0c4C83LtPWSLtaDLOWThUS5vwA5I4AANlOamM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Yd3vV/GnFKQ1Si8aDvXNckYOzqGMevZsSSVg3Si/c1UPJJKCy7iR64AX8B9ZKADt6cc0x7xGrTIYfWCqRIdBd1T5U9COj+PhIHSB+kvYoJPD7p3y9HSJCBDYByow/IJrOY0TT8Mky4Jv1ewQ92RQpa+anGk6u7ReN8HaWoYY4H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=deteYtUz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PjcPzFgs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="deteYtUz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PjcPzFgs"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLjwPC008847;
	Fri, 25 Jul 2025 01:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j0H1t5YOMCGshVUznv
	o2XBOZkkSjfJRwQTH2Pbwwvcc=; b=deteYtUzTZU8cN3T/wB1hjaYJAvYRmaxuE
	Lar2glGrzpb67SfUV9GzC4kFuetJ2fqe6Mm5qgACT+huZHJkbnzKGt4CnF+JpdPe
	dW0foDKSO3OYa8DDYnEo+PZG34FH/aV5YESb4jPSRXPIBxX1hYGq4/bRYuLM1uJd
	4VvDC6kU0xRNxFgdJMQZ8wJOOWGB6yrDukcA/UBzkw0XLqL2iMvBnGvwqrfuBIm4
	d3YcaM76BkVsDaSzt6pFJ0jU3Zb+2TAwlFDLJgfDtDjnJWtCgLBdo3DvH3/pABT5
	g8+U5KIAGPM8ly8T1i3Ih8VfZEwk66CvyOJV+rBLKXD8iyvBWt7A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jg6tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:58:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56ONYRNm010808;
	Fri, 25 Jul 2025 01:58:19 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcg9vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:58:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l6OzDnajMZKNWVebZSZbYVJS2QLliVxJ6ilpQHhHz8YyQJimLqMycfALmSRotQvp7XbGkIjTKVkArmY3Qe+xFEcMpf/A6trZDP/0jonv8fO3l9GrVbvafz9F9vyGRkafxEke+Ttn2FaFYgJIJdieIIbusVdsyYdMnCkA/ozvy/hQRM8Acm4dITVoM3VsrDnJBp7bVey1SuFQKPjShUcmdypC1KWefPhL9Yd/m6zA6dUqxykxMeStS0WQ9aUoQ/dBS2tbvfY2xwoUp+DeWcl8rsNXbhwIcch55nBUqG00sSLHjOWPcCt7mybvS9lrjRvirrGOZasD52tphwgvDV4Cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0H1t5YOMCGshVUznvo2XBOZkkSjfJRwQTH2Pbwwvcc=;
 b=DR0pj8OW7GXgC0SE8gbA8Xj2Niu4W4twPMC6xst+6rpvDL/U97wwgVgBKjeEWP6K/2ZK5DJvVMh/mnT9glMmB93UzSD2lGrrJB7XB0MaMKBX8NKmKkwmZfa9vaiow4JzL/0G+/lUM4Ka5OCA/rpweHUqnaCCMfBH/klVPgy6WdLoPI+8VfVOIFwrZ0CLrI8N7K1t+9/9NG3GINBqkPX67RD15Lalggwn8XSJDROG9psEUQl3/W38wfAFUpb6+clKejeTNHVcSW15l0fxYz2q8ei5lCt770bqwZmtMMy9n2UIHvxxOlE+LlDbBRayS/lM9GVu36wchkm9S0golLvMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0H1t5YOMCGshVUznvo2XBOZkkSjfJRwQTH2Pbwwvcc=;
 b=PjcPzFgsz6y3zocqFYPuPuvgk8QVrPBgBNTk6x8MhLQntaFa1YUFC68rlWYNaRjHBtCphBbCWe3KjRStjff2Fzsw6MVDEDIO7oLOxxnSB7bXc4+NI4zprAJmBFQWW4R5/nk14R6DRFb1xVHUqPErEEr80KQ9dgPavWWXgw7fdfA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7035.namprd10.prod.outlook.com (2603:10b6:510:275::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 01:58:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:58:11 +0000
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: martin.petersen@oracle.com, michael.christie@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mlombard@bsdbackstore.eu, bvanassche@acm.org
Subject: Re: [PATCH V3] target: generate correct string identifiers for PR
 OUT transport IDs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250714133738.11054-1-mlombard@redhat.com> (Maurizio Lombardi's
	message of "Mon, 14 Jul 2025 15:37:38 +0200")
Organization: Oracle Corporation
Message-ID: <yq1zfctqbfy.fsf@ca-mkp.ca.oracle.com>
References: <20250714133738.11054-1-mlombard@redhat.com>
Date: Thu, 24 Jul 2025 21:58:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f82507-f201-4034-5a7e-08ddcb1eb558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?maBNAz95OjRffFwLjCGaAKeJemw8xqVx2D0qfL5B2Bd4gTk2pZc5KwLZO1UE?=
 =?us-ascii?Q?wNW/nTyeG5vaktPdO8n62+CFtnJcmM/kvXiV7sKWUNKcjNnj8iek5zLyNfp2?=
 =?us-ascii?Q?yOA4a7iDvquH6AY3tLLgKTWcePbu22rpXFA1iKghxYh6E3FoRLIWm7CnH8XV?=
 =?us-ascii?Q?kzVyvsBdmkEUXug4naG86vKbSPz4utjfaRTAUher8NDS+CSuzUd2BrP4D+yp?=
 =?us-ascii?Q?0oWBroh/Hy9VMS+DEM9MfRHRAA4Od+RPw7AOfN+eMSFJhRhotAJ/kzpCsJZC?=
 =?us-ascii?Q?+InGftycritkhAikxDUm8KCv4JjApxgXLy+QPBHfjrlQlu7nmz5Ie/twCq+x?=
 =?us-ascii?Q?/hzZQwHpVtic2RtOgunu1whVwh6e7IW4sdua9UoQNm5uE5pjf2VvBPZhi/3H?=
 =?us-ascii?Q?WJDJBOiqcnInj1ocQX5VxcP5K22Ac52puxRFsfHjRRqLuZVXn4+HMpvUhBf9?=
 =?us-ascii?Q?Zo0dMgnSU3SiHSetKjNU5Tjzpz3oAafqI2bu8tGQexTpxapaWHHFgT9+5Plb?=
 =?us-ascii?Q?DtXloCHI6xizlycV+nH/x6myn60GYZ1ksTK1OwYnyL31PxVKtr5tc7258bIh?=
 =?us-ascii?Q?otERf6n6+p2nAiYNS3C8+AYo5e5UID1PsGLV7qnd03X05jFM/Qsxzoq/+Z8m?=
 =?us-ascii?Q?TEiE+UO6CNhCf1gqHlvbkmZYTVal23kgAwhVagmt1n5IKXRMwAJsyyOcM0+Y?=
 =?us-ascii?Q?u7ABqc/lIyzYM6/STwl3uTWjp6VzXs8O0J+/dz7Az3OmyKEfppx0oXITzIpK?=
 =?us-ascii?Q?klHY7DrsdvFrMj+txMWGdJlQfTn+HY7aJ0yvPR006885g4DshaFHRvFG4Oqi?=
 =?us-ascii?Q?W0StlPnB7AEEJj8+0CahD4cIwYnrwCxR6eQmxncj7fegre1CntcfbFkD4nKh?=
 =?us-ascii?Q?1mWyOZfc6ND71f8bBTQoc5PUGF4QjN8S5RpKbYc0fTMWqF2YArdDcMN0vpgA?=
 =?us-ascii?Q?Dvzy7WskKOY3pW0/Nf86P80//m3Dntiuxya9SA9jYMNfbyCVfYpuh3FhwPaY?=
 =?us-ascii?Q?O1cuAER/CUzEqYmIk2Kx4pEaoYJz637YiFUdim0HgdDe+gPe9f/+zj/h9fnt?=
 =?us-ascii?Q?CQqYos9TDbXDZLr1W0NGz0gFhb77V8jHlGoY55P9lNgZ5xMYx7+svkxCKrIZ?=
 =?us-ascii?Q?pQbOldohePtp1a64BlJt+dYCIzG/2C83dNdNRn7JkzM4pB9IrY1uJjx0wkjc?=
 =?us-ascii?Q?mETK7sCYKJxKtcnvBDQrEmHS6FVC7X6jCGo3N0fZeujqEVLTMs+ujq/OYdfc?=
 =?us-ascii?Q?DRQWKCmlgMxPufozMaiPHqc0jxG36oSYF6J2ZW7lnkIBHH72HmgdI+/HRw2T?=
 =?us-ascii?Q?ckYhfAWc8wcPu7zWyFC7K7DsvNp9behUu5Ecr+xF5nr0q4iC5F4+J48hZ+Pi?=
 =?us-ascii?Q?/In3Bub7hHNFnpfoUbz7zd7LnA+ptyHKOMn39Pl7QFxzlzD8zW/lXwsibKI0?=
 =?us-ascii?Q?svHuvmnO8Ps=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?heNI+T6WExmbF59R9yrrRo3o7kD3Sb78LUOgMdOkNqNy1d4MbrajwsOUYTQk?=
 =?us-ascii?Q?M473lACLuYOgFjbsmV0Z59q4WXpq7dErkDHtC8TCoTQ40yx/Al1BdiLV2hvn?=
 =?us-ascii?Q?+y8ZB0xeAYFctBFD19XSHIwZEjW9nTbWIQu/LGf53YqWNTQPx2vzHr/d2nPv?=
 =?us-ascii?Q?o9yd4/2Nijp0NV7TngQCnObPUyRu+eqBhOZiP55jDUra3dN0BOOrBO9Ar4JE?=
 =?us-ascii?Q?1uUsrKS7ekX/opkErVVx/NRxSYATUYfeQJH4kI4qlevO6Jd6A7k0phG/TwdO?=
 =?us-ascii?Q?GYaooZpQqj93Q1UrUMM6p3lRM5ShjkyMsew0MO2kRMnYDzKZoZaCAGYrselV?=
 =?us-ascii?Q?hs0HHxABiHeqavdpM37uYgQhrpWY/UyhiAwDfknQOb3KYl796RDykXgQL772?=
 =?us-ascii?Q?XYxhtfeoErsruub5/j8Q2GKzz7oHx17nw0lJqcZ77KeOmX7q4YwRh9vrh+Uj?=
 =?us-ascii?Q?eqljhFkA8a8+4AgpNQpqMk+9VpzhK/IF3E/XcIj428mp2bWyf9Gfa98pqx2k?=
 =?us-ascii?Q?9vqS3NZsciXfgnGU87EUeA0ZVJ3ORjB4To6JjyDYjdvHo7jN4ICyyNBZcx2u?=
 =?us-ascii?Q?AKx0u4SdCy9lMrgu4j+3mqlWO/v1YCAilfNeBhCYMJHzhQ4OvEfgq7e7U7n4?=
 =?us-ascii?Q?rpFkvhp7VsjgiGSEa0DRXYrFg0Q6GCmm9Iv7bqrkxzXOZEIOAvEsV1V5VVhs?=
 =?us-ascii?Q?lgU7cZ0O0QDAZPEMKAD5IB5/FZh8YXCQdofvXx1a+hcFZOwwhA8CRMYrAiSd?=
 =?us-ascii?Q?12/p/iTD0TmhO5pRvxw+S3uNlHTx3LiSIhQ7Zt7v88c7XMdX2LjXXKOu4rqh?=
 =?us-ascii?Q?kFMNnzi6p2r9Z3pYP7nEjzvHPUI9vMhl08vIlBME+/4+XgP8GaaqOmgqsu/j?=
 =?us-ascii?Q?WEnTimzYqi4GbVzUgpgFdxJv7YePvAZxKej0yJl5nmRNQw9IMteSP1X1fKJT?=
 =?us-ascii?Q?69TF6sLoLcNA47BIS3s3EcpqGooQgnBKUOFhDWNhzWBXeSijEGMaDwJo/gnd?=
 =?us-ascii?Q?cclZEW9nBwfgZtXDBf+ZmEbzOxWsjA/9pWTFS6YmgV55O5FGlbt8bVr+gBWR?=
 =?us-ascii?Q?gTxizyiY3POdITvTCSFRUCScaqfwtBmJH/5zjlLF6M2g9SOxr5YKHTLVPsEi?=
 =?us-ascii?Q?cLbwjNuf/whLNTJpZtlUbmMspj26ebCxGbUdEeWwAta9RNR7auc+hDYwzI+1?=
 =?us-ascii?Q?EJSMxGT+8yiYYZDbVW65Fx/Nc0zsXSiXw3RfWIFuy5fKr7h9ct0QMmLTOUGl?=
 =?us-ascii?Q?XlxU8D4WNE/7za5fIa+y2Wc90Y6I/xxT6Tl7Ih888rNtmM2H7jytaOv3nlFK?=
 =?us-ascii?Q?7H3jiCny6NzLK1blpqQlFV1VOGFaushkeSxEyG+L99GI1U07hIbSd1hp8Cr0?=
 =?us-ascii?Q?NOWu32VQNJKEvyXhjDU263XfyJ8rApzE8jnBeX+fWYW3CWNGZJiycJL0SHNX?=
 =?us-ascii?Q?6659AmDtUYCER1xQ3U+VYf24C2UzdeEHLKNbmO+CSRT6XjFxTkvYvtpGsPFP?=
 =?us-ascii?Q?Q2rHA9jTSIw7gOPreYybsXlQA6YtShqbXhYk4vmCrwpVqcctirQgX2jwF8cn?=
 =?us-ascii?Q?89ln/+KPMBEZ3czOkUIhQZkGDcp+HJefvqEe1EU+bmTb7egRFUq6EwuNrJiV?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o5VNNDp9P1c+InyKsMXguUq1NGfme/wPqkIzAnkUA6MCv0AIvpVbqTOV8CBQRh9/U39UihqEhjoEz7jgpGpsYKWKCAFxS9kE8C0TI+rj1Do/KzHIadqrBMvASZ5niW7jHOkukwmfZqHZlQZXR3Glv6wFYxYQvjyHpy6a0eIthuV0pMnb4683mUgjy34hhVoDs70hggDihnyXU4gk2HI+SVR5isvm/D2QLuevXDCjfOEdwtLMi8ToYmcucHlsRJvKjNjvDhKz+9DotrU+KOxDaAqOvIH6OUg6ActUweGX2nSbmv6fpKgzN4YphUdkxTrrZ31p2Ws4RQi0eXfCxoPAst4RGj2ePmhrsW6T0gTlCei6sGCr5opDAzVUPGa025Yj0UrXkP5Ab4WKp2zkrLy9hcsfxVUFf/COPRJ+yKnfhkBJy/SnEuCqB/ot98TfCPx9Y7YklPUoDtjVZ5Xbam+nLdoepdCI2a9NQHzJboymiGnoYRduu3KOlcqJSk7Hr+f4/XkVfuL5KbPt9Z70/9phAZ1hRoUyXwBEgA5pHUUy0ClRN+P0+/+PhoYCbBFeeRdBczZoKeWgsfsbdcYhhmZtkrUjLw1VZqM/MZ8X4xhdTMk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f82507-f201-4034-5a7e-08ddcb1eb558
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:58:10.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMwfYbwfqKppSTyG/Ae4zwcNFHCPaxSI+my2O/mrtBMQgykh4xXhBmDljUhuiBfpSpw/M3r4e1P8+fNh7b0I7lQaH/QeLwrTLI6Y0yyOfyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxNCBTYWx0ZWRfX/ViKiAJ6Sy1X
 sY2qHG8o0H4LBSAw7DNUOUVWiKR8TGQS+N1af2MNvBb5XHsq/fl/3S9zVwZbcGKSSDGvApRA6Xx
 YJlVEd8eAXH7JsuRnxK+hwDy5FgbjDmcmEU93oSgynE5Hmj0hJhzijSHfDz8+XpOo5UzPMajj68
 m7yQLjD0qRi1hKKPRn6iTn/dgLxEjjCF3Lp/gMAQj0mL3nzOIB4IoD7imtAPxlEbj5KW4zDLakk
 DKUFiKogo9xZVWjnUaCrFyvLo2b3pnWDCCb77ATN3XhqZpodM8HqWCaTWlkzPU/Fo+sVMYeydUT
 o8DLoNFlziHr3RuBYqCRoFrPtnxBvO/UNS/I2pbQaEZxXaJX0tD7DpOhDuTZne+rQ/+jtlxnnAa
 KmWVnSIaHHssiLK8XqYzXZ/g4kdsn7gBIrbHEX7AjPFxJZxQhLNT9/jvfsu9agD4qqBluu4+
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=6882e4bc b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-ORIG-GUID: agMKCOR8-QFLOk_9PC8lM1ybUs1h_mrz
X-Proofpoint-GUID: agMKCOR8-QFLOk_9PC8lM1ybUs1h_mrz


Maurizio,

> Fix target_parse_pr_out_transport_id() to return a string representing
> the transport ID in a human-readable format (e.g., naa.xxxxxxxx...)
> for various SCSI protocol types (SAS, FCP, SRP, SBP).

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
