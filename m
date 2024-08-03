Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6125C99;
	Sat,  3 Aug 2024 01:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648568; cv=fail; b=hmAnwDfQb2ROALOIjPGa3iHJZkxdzlagRVPLN+Is3OfnLZZmYUX98LoFGaYH39MPCxytXciTv5cac0sk4l41Lj9JdX4Gbxt7UM6Ap4k8pWs+uYJJUclAzs+QLiJ4jXEna5mZp4lZ2AJldfphXElU9Br5OptVDSxg/WG0r/coBx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648568; c=relaxed/simple;
	bh=382Bsx73gh/79NveuKcvcX2fCHHqZs1vIvInbfxOvTM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aofV96xnRF7CkQdXuheADS3GjTWbSmJq7RLWRqGxxEvL2DJ/zD2DxQoIfu9UgRXl+e62L39eckAqsnW5PkV1psRYPwMsZ6ybEpFXvadBierfxoCBTyX0OaDqzklU6NLeNxvpu3Jc8fmfT03eDTRitLUf+AQ9syJSxPGcw09U3bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cNWJFKS7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gK4Fxgwv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cNWJFKS7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gK4Fxgwv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472Gtgnr028656;
	Sat, 3 Aug 2024 01:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=D8EVi5NmSiPYAH
	slR18k7994hOD/p3mH9fab8v5IGa8=; b=cNWJFKS7KkdzWCRNwFvqWAqFZ47St5
	8wv4QyX9ByQUp2eHrhDnOs9FJlJjVCf1gBHgRQtjaMAieDcpcCbds+0Hihpxjarr
	+IQc8adCA2QLdVyRAlYUZVeLpWVp0JZyT9N9e9UfbuajWAsMhCItLoFpimMoOrr3
	i7XPVlIbRHt7UEYdQZBqUCUWXXXzlbqP//unQWnKewYpNCY2yTGS+v3IQpDzngKf
	ZLkLTwkQERDaHlk9z/04aNMJcGtcZAoniEcHYr/jFwnLqpBn7EwQlr18NGn93IGd
	RqicBMNsEaFoqY8J8h9Bz+j/3V/QXCCl+03rzgdjiWSs9C7V4rAnep6A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rje1jedp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:29:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 472MnPpj001833;
	Sat, 3 Aug 2024 01:29:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40nvp2bdkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:29:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhjkXGR1wkaifYRyHeZX7LAuRSHI+f5+j48jRrFfSqQleKw+Or5FkqIIlT2UxZ4WXpue6hjfJ5NpgHEuTb6ECJzfvM1tDKdANbeiVLBAsl5t3l3qwq4fis9oJK+n/pjylhUHGI58A8KNT1PrsmM/0jrrEtqsv4ENeKECFl0YA0CxWgjw9jDcvzxkrLdgyKCU6nLsCHVg3UdlpoSC5e4SDWGsfbry+EknxvwA/G2pQpCqBBQWnL0vPiSih9BY3zYGrwHQRGn0samZKUhAoWnORNQlbBn7q5/DDzgr05ZoKiI83Dq+txmjfk8mjOUDlmb7hqODg5c3vlXHrEyUhGTHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8EVi5NmSiPYAHslR18k7994hOD/p3mH9fab8v5IGa8=;
 b=oL1gx1ov3Bo++mGlH1677PRzzwo60xenxMnuvVkTqXQjSqm8RmjmtCnxICdB/KdohCLiHTeJZ90s5ty09w/MdOppkW4/jwRBMFjfKpixwbcjz2Xxp1CxPNUTfCJl5bwibcwe0fNqUeDsx4SbgVFtR8WWhMqQc0aUNaB2hDUwK9EB+i4Da07ITFXXlZ7PgyYKDPR6BT5MNYuG/pcIqJpQy+9yheiB4BWE1pPnbtbw7XQzmW5CeURykyvdrlWwXIFa/DMhmOy5p1G0R4Wmr81FTqFyu6HLXBllLECcOAP0AnWa9Gq5CdZruzwbsS3S/uxm1J2zf0bJtlocC9HewppzjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8EVi5NmSiPYAHslR18k7994hOD/p3mH9fab8v5IGa8=;
 b=gK4FxgwvhUZFHgdMPsJRVBDoaQQC/YewwF68deXrCyB3vEXoNRSXRU2lGuYXJQ0/6B3Mse+otxiGUmgEkPMmRejFIaIfMh9V4rM1uyHVJrdzacNVs6iX+SU9dSK50usSL949XEUKB9SUcJ9U1NBgpypwGGiNpGXRiQ5x9eT5DTM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:29:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:29:21 +0000
To: Kees Cook <kees@kernel.org>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: struct aac_ciss_phys_luns_resp: Replace
 1-element array with flexible array
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711175055.work.928-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 10:50:55 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jzgy75sn.fsf@ca-mkp.ca.oracle.com>
References: <20240711175055.work.928-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:29:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0120.namprd02.prod.outlook.com
 (2603:10b6:208:35::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc3d9df-1b49-4fba-e05f-08dcb35bb35b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GW85+7541Q4MAR+3W2O4uq56rv45k6cAi6BucGNUupUdhGIL08EWFZYDG+VW?=
 =?us-ascii?Q?SRbwWXN9M6aGy944VhHYkCt1vycYcUoaD+gKuDQauW71mnaD8FJc5nPs4pot?=
 =?us-ascii?Q?ZrjO/LptqpceTyUxgTBldH1+Q0Y15JYRT0aw0QzTICnRulXqyvBNjnTRsDX7?=
 =?us-ascii?Q?jVrHk0juq90XgqIMfg+qqy/NKsPVPb2lx2Wcj9JcZxFi7CC57hu2YMYHE25O?=
 =?us-ascii?Q?Sr2VhTHCSRXKUEnP5VJImbepNXMoIQwLMwZsK1qcCYQAvLJ7717VLUvFn36J?=
 =?us-ascii?Q?2XHKv5wjjoYEYQu5w9KgNEKWBokxmrqJiqeC4O04V/WLqdnzTTx9SdIfqVt3?=
 =?us-ascii?Q?oUjY59fXR+f9clwIRea1U2HL1LTIosg1whq5QWct+9NIcaND3DAGf3fLl3b+?=
 =?us-ascii?Q?E7hjTY+feftsmGGv38i3kT40AUpaIoffwvmfy9JLIgB97Tzot3+UWvWjXW17?=
 =?us-ascii?Q?PIB48RLFkuDR5jrwjXUcSsFJ3Q9+KBfznvf66z4N4Eo7Qvl9+oAEWIhIsaGC?=
 =?us-ascii?Q?NHXjw1IBo/iq43uu7ABIEUI5jXqKEYaeQcZ+F4RfFz47C0jn9RGhJjXggdDb?=
 =?us-ascii?Q?Gf4hBqOYvWg1pXByfSD12nsOyLOQDysKqBkBMJtn1L9LOM5Lnop9s0usJ3xw?=
 =?us-ascii?Q?ttDe8+j7e1L17Uk2ss76Y4+37NMZ8WBeLBAz+re7tbhacYR4hbW+GLfz1TyK?=
 =?us-ascii?Q?WstfCEfZYxhPg905oyb+wT13HHIucwbbAd0sKOsCHz8OrZYahG9Uao7r0RSj?=
 =?us-ascii?Q?sH4SJe25ctkvgBEcxiTesjumXAVqgoGmdZkCG8l7OXIAklejq5FUFickndv9?=
 =?us-ascii?Q?r5qgwpvw5lUF7nZmcdOLbHSeNAIsz04Jkv5cPFWwmKcSY8Y8HvSiRvDs2YjV?=
 =?us-ascii?Q?olZbjLvOahaPP1aGR3mwRZEU4Lxo3VOlwy+cmYvQOVUcWi2u3yP+baQjeHTB?=
 =?us-ascii?Q?x3HnZk24wNshXQIrTZPd5kVP5SzINannk4tSiVu0/VoGBmZcMJnHG+EhEUa9?=
 =?us-ascii?Q?YFDNWRu70U35NbpnbFfybAXiA1APcDRCmkkpDjugA+VSU++ekJZTnc0zi0kS?=
 =?us-ascii?Q?57hgMtLZud7xEFlLeLI2ohg3gnnVE/a8PO/e3MgIwVGd0nfROVhWMZraKxlT?=
 =?us-ascii?Q?e0ijLQECWvlBNkRCWgNLU1brfRo2a8qJlLrPtak3Kn9vQf2+Iy2LFHxBtL8Z?=
 =?us-ascii?Q?CGhbB/roS4J8trYVUqHSwytYMncXfsg+MCvxFqhCrRphLOTXAfg68YwlkeA4?=
 =?us-ascii?Q?Jsy7J7FygRA5JCNeniy4wGyUb5mDg/FxnKVlx7BlarDBI9IDPU9eGcFm6rE0?=
 =?us-ascii?Q?dbbhtrsBbJALx1ISGx8j/xblEK00Ngd/ynP49xVBvKvZsA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZCG+su4ZdkEA7dRfbXdild0B2hPPP4tZIbNUhtSx/Cmb+zMi2y/w1gPsQrwp?=
 =?us-ascii?Q?EPpkxYKThZZXdh1K7rQkDnH9MaECJEzd9p/hVx2ikuchIenFyrIVM4FfEqM4?=
 =?us-ascii?Q?DGWEzG+JutBnM+yK9N5hiw+0/dNwOTbTMHXBpIq+w94y/xDunF9YpD/4hCgX?=
 =?us-ascii?Q?2rveRSNrqAbIExTyURZbQNPHgLU3HXWO6ndXfptwcD/pJJaQh1NkGqAilhuF?=
 =?us-ascii?Q?OBg6+fiKyhkZ9iPzwN6cMXVCEAjBjJJo49mCGftXXj+w21D1CoZbF00/jG+Y?=
 =?us-ascii?Q?yOzPKnLZISi6+N8A2u/vRW783Xh9HOZ+Y4JlUz+HjduHDhQFrruZShaKf9Cj?=
 =?us-ascii?Q?GBNEsXdiKgNEeAGGyX9Xd5k/XWyKyWKrXZshdZaDnEsprQNwjWGdjoEskdze?=
 =?us-ascii?Q?HnEGMa6lw6WT014vBvVlLyeQPB+GR0KLaDlxoQcEJDBW1jrFBtI0hRHIpiBk?=
 =?us-ascii?Q?DhaHTSPwZJLwW2Ncdtq1vUtLbMDCPLLd+Ql8Z6a9u85sKESlFl2EhMMg8tHp?=
 =?us-ascii?Q?2a6JXhiPLV2rnJ/6bzlktIU4gUM/w3m6gCSdP3Do/+X6cHag91XSqS4y1AhF?=
 =?us-ascii?Q?eu91Hj4lXf+7KTdaV65KVpfD9P4gH7fMoNK7gCQAvBEV9EjN8Db04RJSGD3o?=
 =?us-ascii?Q?L9xNVEeZ4rqptJkUn78dtuMWbKoZd9jmEg+RgQLvvk3W+hA/659JiwohaD4a?=
 =?us-ascii?Q?X0/ckAKKV6HlRjCLwE0fxByoyyHbsBSd4y+6NjmwC7GAsWP1397S7RAebkoL?=
 =?us-ascii?Q?hQKthbvozh52Pm507PEgLdRzWkntosr+dhTIZuB8bjoSnlQ1dFLRV4iDoxxD?=
 =?us-ascii?Q?nMW0CQ/FyCoAPopG/fl6y0NJuFZF2rtt1JGOP8ov/HNGCDv4CmJ0OQoDqv8D?=
 =?us-ascii?Q?JvVXbffZWLTNDmU6ZkhWYw39QT7jkBAwGOwqHX0pJYPcvhYOi7EB7KkCtvpa?=
 =?us-ascii?Q?lfiI0hZLMzvavRKwzCQyYOWaVP5rsX7tp2nGawleMk38vbg4GJuX39ZJ40sH?=
 =?us-ascii?Q?LveWxtUJfLXIa86xANZwixONl3gEaB/t0kwPGsTLxn9/r2WT3cYVt/6vc1pK?=
 =?us-ascii?Q?ROQX41Rm1daLZpw5FTkYXsDSZwIVuVtvMWUFADfbBxVV6I6l86HbX0vZPmHr?=
 =?us-ascii?Q?c/HzfGV/BV7GGlnL/O4v5ilE4l8RcFCL97c4S61Ce+7ewuwRyi288X9TtVAO?=
 =?us-ascii?Q?79nxQ4hNavci+as7EvKQZonpD8Gm5xiBOGi0fx2lY05pbYSI8jOQ5P2XlRQW?=
 =?us-ascii?Q?SCD4pBDiiy8WgoZGkBS+FeWfRvZDt7TdYQTJ6j4C7QJ9K3AbHL2Z00/2rVDz?=
 =?us-ascii?Q?jjhKm6yEjWqATEFyfX238Rdk0uP9mIc9wSykRWQT9f74uxqa88DL4Efe9v7S?=
 =?us-ascii?Q?WBonfRkoeg8Hi1Ix64Td2tCuuqWjlMAoKv+StNczSAX3dXvjnUlT0kIZwJtL?=
 =?us-ascii?Q?GM2lidcg25sMP1f1jy327+28rTGHiOxmSWsLPtBDoewHAcISSMxbjILn5bKl?=
 =?us-ascii?Q?zqtUbEnqZiJ0pCvTxstJQws5NKuCc9UYTZrIn3Kv6D4qdMgh+kvjbSnhAJSV?=
 =?us-ascii?Q?PIg2ZStjnheNd4alBwTgd2cYHU5HWNkjBd38Un9btrLMm+pg0Z8OnHurgNEY?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wfegg4v+v8v7c06n6wojBHYHbEMS+UU4R5Wek1TZZipHy7oxJcUnyTPPvfnVIKcbJZJWd9La0413kbAk4FwFag4DSXK4v823VN0GPKzqcRnIfxbLiweqBIu0tU/gBZScwSoTV4LBmu6S9o2QNcUzspa3vR487/AOGm1H6ZJRwngbQgEWO21J/v9lkfwdjXfGjhevshXAlItwVCtSb90H/EhtdwnJaiLlVXzljI6MqJ/37UJDHjWi9ynuKs/e0MlX1oxy4jyEzI32Fjinggp5Eo7qiIKLVVF86lKvqAGlgAZ6x32f4Jx99jNB5iB4oBO+3P+Ua9uvsEdo5ebQ5rAa6N30RdUMUeXl5omnGse6w0pgpYBkOiXU1gq3x07ktoUrlAkCdRUMdKmWSY5Sr34xyca595gUSINZnSP3gCgGzjKxlpQZyr7ziTiaqcNMUqcJqFrOj1Fj+mFivlofh08LV2pUh99r9GgeHnKztrGVje1Twlcm/UF0p4bn2ryQqbgdkCDUSXmLRPanNdmEOguRCn9jHqZUpPOSPFxlOcgOr6IaPbPEBhpjxh8n8rqiNC0O6L08+k7z0YX6R+8uASLajNlviFgnZ37CrokNW+oV5CA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc3d9df-1b49-4fba-e05f-08dcb35bb35b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:29:21.3080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zstXqjLsVpqU3NwR0Ismt1KZD7MtjsqX1aUXb5SNM3kEQXRJx0sd07husZvKPEguvk5UwGZ47UL1FlDdEsihLJlWxrFRGGMcGg2pK3c0x+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=782 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408030007
X-Proofpoint-GUID: CxNBgYvZOUITe4IIjsxHVUb6tB-UgqrL
X-Proofpoint-ORIG-GUID: CxNBgYvZOUITe4IIjsxHVUb6tB-UgqrL


Kees,

> Replace the deprecated[1] use of a 1-element array in struct
> aac_ciss_phys_luns_resp with a modern flexible array.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
