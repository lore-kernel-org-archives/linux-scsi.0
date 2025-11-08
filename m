Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0219F137;
	Sat,  8 Nov 2025 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762624445; cv=fail; b=u042A6V6qmy6u+1BnDo3xS+VvKHflSmZXFLMsjthRV8ylv8jg2wXETxS2FYRtGgEsQ2g9Ury3OXr2hFwKFJhixXMTpjo6Vjk/meWltGmM2uU7gIbzA148QbI/Wv+dGJfxwcREANgyNmB6fsKNEx32v/bZMNhrdx/UqOdaIDgFvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762624445; c=relaxed/simple;
	bh=hCywZVuDapoR2EajcYiTXl+dQkYwabPPfrhgB7/Bb9k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Eecwdr8fzezsxUgodzWfqFjNlNcs9i98+OrBubdvdmWyDrioFNShTrdKXcos2hqaL1P2/0a0rRTRpWlCkNhoOASGV1Q4I1S40mdr8x801vbcvv4fFpQa5Mzoc9H5yS4RVJnxiYbFY7RXaCdczHIEjirDgv1rfr2WuX6twJ12E8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MKyc8ehZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kPynX0vt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKyc8ehZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kPynX0vt"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GodZl023254;
	Sat, 8 Nov 2025 17:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VjFpgjn+uyYARelFS5
	8vmOSp1HpCg7xGVlbBMhaHmxU=; b=MKyc8ehZOs5gI4wnbXInkuMjYv7EkDb5pR
	4vOYdGtcFAYKF8nC7KxCAdK886kWB27mLesEWErvpWs1p7iQIoGqQ+cW/fQc0gzA
	QjwyxkC5ZEXEe3UBIhgqAjMsaw46a1dk/345spPXYKf5Z/wH/e2GOXvrlyuU9RS5
	eZW6fR9QWOAWDfemqgBWdmaX7zxxZiY7/j9DaKLk4CGmqUDixZIg3+ly96uCMsCu
	cZnFOR9fdES5LYHnYPKHjrGtEDvgsJELWuEGG/t+3v2llZZEZju+ImyjfxAG++UQ
	5fyi6nR1mTGWPYL8jX9L5evYWEGd55lH6hlu9MU5QeXVHrzD63uQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa7m604vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:53:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GhKGc010107;
	Sat, 8 Nov 2025 17:53:57 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vagf68h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMKSDYtjH0vY381UaDC27FoUuekfLfRghrzoQlX+adQ3ZSwI2bzk71T/kbOPTo5aKdbC759/+c83RekUnaEywY71mQ/f0UPfDYA0DM/Jh2D91a0tW7GI3Y0M9yDgBdXNILI3c7yWY7U/uvCudVibvUOa7FGZANvQIx4pwHzqsn4wDFUTPJd9nTJ4xjLGWjtCaHZ+aWHIgFYlCHyre4k+cmKZj9jFDexLX0FNlsYWM3rlYI2pP7f5DeHSOaos78N6wcx2G6IGrq1l2JazwtbU0UtEluXzkQuZePTvtU5RdC+zrqdgM/V+RlCF0tqzhCwWSeSxl/883QKg1yRpeuOCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjFpgjn+uyYARelFS58vmOSp1HpCg7xGVlbBMhaHmxU=;
 b=gt6qHFcXvD0GRKH97EjdWOCz8hUxv0exXXLmZbbIv45zwAVt8QM3EEpv5kxic/+3l0k+2x+pPParxWhxXtWoPNHyLMxSJtuYG5GbYB3jFtBzU3lDg3RsffWieNd64ZHNUKIiAmSaIiJmcEMALBs65l5soXkxFEQZszBqmCp5soyZvgJOAKjXpeIGyFRLhCBFIoE2xzY3JuQTVf45p+jGJzPvNhowB79d7RLB7Dl4hs4yykxAOEP2e6ZDK2gQ4nO74qtL2dw77Q+OD6OVM90KxOx23KeRlVoyE8MrILcVWzZ/QmfocZJkw+IEMfnZNQQf1gg2kDqIEBg5VlRr/0Zt5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjFpgjn+uyYARelFS58vmOSp1HpCg7xGVlbBMhaHmxU=;
 b=kPynX0vttR9SzEp2nDj1l7y9FyLsduSY7viU6xZ6jxZIhdDawwcTkFDulHVQqp8QfN6dDk4JZouiii7oesrRAyt3zRL0G1n6C4CFyXwkEL/8G8Cl5DLkUc16ZSMUfzCqtDtJMcuqqgTGIs2IJ2KWJy31dDVtlfi/fyQbrKfv0ZQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7374.namprd10.prod.outlook.com (2603:10b6:8:eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 17:53:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:53:54 +0000
To: Shi Hao <i.shihao.999@gmail.com>
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: use sysfs_emit function in sysfs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251103130501.40158-1-i.shihao.999@gmail.com> (Shi Hao's
	message of "Mon, 3 Nov 2025 18:35:01 +0530")
Organization: Oracle Corporation
Message-ID: <yq1cy5sif94.fsf@ca-mkp.ca.oracle.com>
References: <20251103130501.40158-1-i.shihao.999@gmail.com>
Date: Sat, 08 Nov 2025 12:53:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7374:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df4e875-901d-4178-be2b-08de1eefc857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+83e2liVbAcSHArMJMMPCbNH6JAASAPQ+ls0bOFR8u4owoNuLBKaXWyeXte7?=
 =?us-ascii?Q?t21cpzHSGfczWw4w60dUetrFkiUxxKema9yGOfS/U1N5tY9WIaJ7v2XC2P8S?=
 =?us-ascii?Q?kaEe2cW8UNtKoqjNAx4p2Mso2Aay1NT5qOdwPyRTYtcXkWcsyQliJftb0het?=
 =?us-ascii?Q?a5WN+VWG5LM4Xuuq9yMeRkxcS26P5OHHt/OdnlWOjCxVR2Tv7xsNAk9IlF2f?=
 =?us-ascii?Q?a1yQMeDHj444zZ1/aTDlv2/xX9wCgng+MPzAw8xFREoUUlpphZAnyn1F6sXC?=
 =?us-ascii?Q?hWvwROoRdQ6vgNJAwiRsJB5dIeFZ1KHN9H3XTB5SdlG6wTKJus02jxELxF9J?=
 =?us-ascii?Q?+KFbOobBF/3LJ9iKvlVxiVMuoz2Tq7qlsrftvqyAvsoYHbK4r0qei1gbID5R?=
 =?us-ascii?Q?p9rK5YHSwRchmvtkbmo879uJNL6KDeJO2s+4/6s8j10nlR0GeKA8iIhWLTeb?=
 =?us-ascii?Q?ImUvdonQ5RkFUbs3VWzJ5MrLjBdMhDNmN6Ot8GFM4VHKZI1ehLc6VNqvpgLv?=
 =?us-ascii?Q?ot+ZOOWetcueeczUNZYXAxZwrlkJ7lpwoH1iYcjGaEBOidjsjRd7ZKjdmtOo?=
 =?us-ascii?Q?GNwUynOmXsHBV97K/O2weH7Cf57U5BYmZ+2NV+olMaHa5ESKU0HTPntPmdSu?=
 =?us-ascii?Q?c4k0/kN03XlvbUBJxJH1gMjfT79C+L3PcFHWnn4v7jJBxAmjDcItLEGmWjeW?=
 =?us-ascii?Q?25ZOmLYdCW15msxIxu5qmsq8HSybsMxpQHDE0O2u824wWwqdRe6PbH+n3HLR?=
 =?us-ascii?Q?2Nph5OdEicZJrpBaUULA/pJKgQQT5U/MTLx0xQ3lJqHT16OlNjNZoBgh/nUu?=
 =?us-ascii?Q?wHexhoEfNafS+jjLi8FnlQxF1Ir3uoprZxg10NfiiF6dKQQE1SPIPlO7jlUP?=
 =?us-ascii?Q?mXK7deXBpKxlUSBNQjSxp1T2nFAXlJE45OsNeyYnqgZNUT8KlQh3u8Ap4OBn?=
 =?us-ascii?Q?9kFyqKNmrupE7Xgr4nz8ucWbL/p9rZpA1GPLomTDa3SBH4RNFR0U7+9pAx/k?=
 =?us-ascii?Q?NwJcit7zuY6Ua0Z1KCFLQO11NwDaO1pj6zxQs5fDVYSzzaIezca7giVQWOZN?=
 =?us-ascii?Q?rcdXiHjV0orWaXynsNc5VTJjSn5O5wp6xg4XDUVcyrvomDwfhZr+O94GJe01?=
 =?us-ascii?Q?nPIWTjrsIISlbghESN8RjC37/d6F/JJCHMzr5aSI0ppEfViLwcHlkExsKZku?=
 =?us-ascii?Q?aEaZh3XL44gurYd98KW3ozretgSsZuwnfGR85pkFfm6tzwhNiU3soorhvk8w?=
 =?us-ascii?Q?DwZK7je3nznaDYAWZEkLZpfbrOTlLDyHVfNa8wdUr/8m2vCAtYxA29W8c2ri?=
 =?us-ascii?Q?MRc4nRrdILvYzNbfT05tBAoji9I+KHDysmiGgNBexscn/hFiRNVKh+mutq7r?=
 =?us-ascii?Q?GLuuiISzbNTjqBecyxrhAUSM9Fu/t4K2P5NidvNqa3QbSHwiFqeVrsA9rQTy?=
 =?us-ascii?Q?saYAKxjUD+3HXfWeYACYthERq9aq0blO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NulHa4P1/Imr/io1Wkeky7Br4Gt48MJxDHKoD+BfXm3QYTOe8zk5XJkqWhKe?=
 =?us-ascii?Q?Npomgs45YsHDC28KluuUjy9oQXYA+FS97RQYrCvv63LG9zb4JU6NQHGk1AF2?=
 =?us-ascii?Q?EqyMrzWAaBCiroFEGl6KWYL5x9VFXI0TQWmvKxVjJxs0f+TzchkObTzIE0JH?=
 =?us-ascii?Q?APRsOma1VMLvairJcl5kcranc/PydSz/03gDI06a2W/fPpj/q0ypzgZWkQLx?=
 =?us-ascii?Q?Vx8yfpApe6VATnpyeXu7t5chb73cCiCA1EupFxO/rCnz5Nhw5zpeZAbumdRd?=
 =?us-ascii?Q?qq4E3l7GhCFCxe+JP9eIiRe/N4aH8KG5mnCHNqfOsoq+3Ntjh06/9i1CMnCs?=
 =?us-ascii?Q?TVx/ZGbThLJi7fMssY7PEtJEe0DuP1W2W4Tvxf8uN6pA1Rt5hD83HV+E/Li9?=
 =?us-ascii?Q?TdqavpnfA5VUCQTwktSCHluKed8laK3KHeJYVyeIzxnbWb7sCIZjkH9YUoId?=
 =?us-ascii?Q?XEoDJ8arZXg50tfDHvXU9lk7CjH/xZW+6Qhw4xfnEkvJ3LvKf7W6CRJn3p7T?=
 =?us-ascii?Q?UixU3iERBYCly7yg9jdl4dM3Yr00JYaGSM6gYLqj3kfh3e2LE8po3m9uEqNk?=
 =?us-ascii?Q?TzCsT1pIPeXL/fx5Eb33WJC3V88gbZCPMDwXINKmJY8on16dnCy0eTb5gzXf?=
 =?us-ascii?Q?T8K8OhhB2SUa3zfDDTh70dES47SV2DTqbCmkqVRKPiGkeZkj/CAEHoLxlxUL?=
 =?us-ascii?Q?KxbGrO5jsrb81sQ6f9TCaaqBi9g3Ub+LedKNRTBhNrxcxhEjJuIwgeYFp4e8?=
 =?us-ascii?Q?3D6Znzx0Fht4pVez2b2K260JIrSIQiI29Z13kU1XDTc5WvwT62mHwkHz8tDy?=
 =?us-ascii?Q?X55p4F/WXJpN6NNkqdyTG6Dd4d/OQgC/GPGi3Pgsntj8vq8TTG7ILYoxGMsw?=
 =?us-ascii?Q?/X725q/TuGXBPcP1ixZv80y4J+Y87rE+K1PnK5v4uva/fQCUvlnG0o8304Yh?=
 =?us-ascii?Q?Ib7hIaQ726/dUUpECmTZmwY0RBQfBoczEPS7DqPU4V55HxvUVz6W8DuMRvG9?=
 =?us-ascii?Q?5xXKU3M0pShz+Y+8TFyiAKPKC0RkLPvng7oUJ0YV81eHH56K0gGIYP28ue1A?=
 =?us-ascii?Q?/k0Jyxly0DsNJllO7UBsiKO/kR0Bh3C5Nm0W97zUv6KDJnGhVaxgrnvNlRXV?=
 =?us-ascii?Q?5GWnJc238BFsM+Cs6hK6vfWBi0HmUNM+byKwErzw4inbmZzcgspLziriAUjE?=
 =?us-ascii?Q?JUK3xa6Hx5e7aKb0hHMH6j0rNmqY+Hy5oWBh7/5AHkBvWFFbJrhw8tkQuxxY?=
 =?us-ascii?Q?W9fV7C7DJ1qjaRpD8Fw2fhdDbOoRTvHYkrbwhhewYiZEDMiV90wusklZiRmB?=
 =?us-ascii?Q?aKPV7itMRwUhuCT7Kv91LCzEpHeDeKnpM7uIX2CnIEA7fKq74O9ARM4Z2VUF?=
 =?us-ascii?Q?uIQq9qaWkGdS6QlkTFAlsTRio0XqCJpUsDsIDfY7KMwt3H2VwXAqHQi6ZTgL?=
 =?us-ascii?Q?ZV4yMG/rKmlF6aXcMlv30S136jYNCN/z37xfOYk9HcCRHwOTUkRity9i/pjJ?=
 =?us-ascii?Q?buOuZSMet4E9eFMT3qkg6aRmfC7HmaUJEJIJRpBaizfHajqBNAt3fHeCq7n1?=
 =?us-ascii?Q?cTbCIIUTWVHCD1AeXPl7xPToQl/s+0A8u0LSJFQYMW95bUNZrsJQSwlSp7Xy?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BibWOsO6VHmxLl++FZ+nzRCFHkU25hRsWap6kVHE/tcUTb6bC5iSQvfDIyqn+FO90hUXWyJ9vweu7SLGfIaR8jd1IfOF9lnweDr5QBRGPOQJp2boAXPsrEZvifP7vDmtXsU97GBvXWwGbynx2O9BZqfu1E/HjIpNWc87CxJiz0nVCDLWXB95aUJ5EyYNNBXKf3otgMqP2nDJdnLnomxY5hNYhnvGB1q0tzaTJafn2iSDxF7+treVQtUm/vIYyPBiz21lpooaJpHoML6TRNaayjzu2WKymNQVqZa8wigOnfTr05FTDQCJaOE4T4j2Ak0zlJ49eWQzzHTuAjUdsB9dyJ56A3xw9hdfmR6DXC9dAY/L0yootRVc40SjRDjIHEZeQrGOc5D7JzrzMyJUj/xaUC9n3bWVLqbwAzEUC0NzguIBeNsBijwqLDI2xXO1XA3eG4xu+AQunG8gWb2RLKeVS8zDABOMPs6RSVjS7vItLeF++DLRGBKsXtCxRWId2rxlS1EmN+JQH5sABrLcEAA/rb6fpMhhTWEO3rSFKJrY5oR6RDbDw1APF/3CGt+zBktX8ptHsdlZLSmIB3guQqGhpcWrFZpMfuRDNNwfU6p0lI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df4e875-901d-4178-be2b-08de1eefc857
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:53:54.1587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7KkXaO4NNtxrURtKL52gGI21sXlc8+ehbU8eTmZIoo9/AZXQajMTORoV/ns+w3lj2H62tKt2sjDLWK8NbSWpgx29Zox5+klc99g1Nsqxyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=669 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080145
X-Authority-Analysis: v=2.4 cv=fvXRpV4f c=1 sm=1 tr=0 ts=690f83b6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=HXi32rAFDqBFGLQ3pRwA:9 cc=ntf
 awl=host:12097
X-Proofpoint-GUID: oR1qqPA5OjO15NinT0hybU7GLLkixkJp
X-Proofpoint-ORIG-GUID: oR1qqPA5OjO15NinT0hybU7GLLkixkJp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDExMyBTYWx0ZWRfXwj8JDaAdvik4
 mE6adClq9em7QX9jGaz0+WLHgBlJ4qNliShELzez1wqqRgq91hTjpTN0NQt/tDJJznYpBubkHTW
 /Ar1/SoA0/3yJGWpTENtuK6/tl+BEOg8eyBGZJK6QrhByCf6I6v9x9PUbCy7xnJaG9/OmfHXEam
 4XClHdtDtBQ1CQeItb3A5jQCFxyOx5mBFFDwIP/U+GK++tDLtZ8Lofs4kGE1dFMuwrCP6pyhPIq
 pI+b+IuzeVFd/vu9cOnV77UMMB/C8OY3rKbPS+289HjvSz41jA/DklOEJjxYVj4qlB0wf6sWLU2
 cSpvOXWgjxAG/foto+NVUhSTsPMmcQtk5LyrJckybcbk2n4iQDF/y3d1HdRix7CagCgLH9SB9eO
 9y6yyY2yLAPFhcJS97W1/cxs0G8ElXJ9eMG4rDX00/ouO6xPjHI=


Shi,

> Replace snprintf() with sysfs_emit() function as it removes
> unnecessary use cases of PAGE_SIZE also it is much preferred for sysfs
> functions. This conversion makes code more maintainable and follows
> current kernel code guidelines.

From Documentation/filesystems/sysfs.rst:

 - New implementations of show() methods should only use sysfs_emit() or
   sysfs_emit_at() when formatting the value to be returned to user space.

mpt3sas is not a "new implementation".

-- 
Martin K. Petersen
