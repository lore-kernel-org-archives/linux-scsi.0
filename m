Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7628C13;
	Fri,  4 Oct 2024 01:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728006608; cv=fail; b=ZzCKsk+wWpdNY/QjsJqhFr0kCy7MCc2hNsiLLXPyEyuLgcTKQDxiA7DOuByuzLJP0w6vXZE24Hj0cRh7Hc8glBWzPZFkfWO3+PgRh9q+52Z9fDEBxpWmnfuTimUdBsSepRyZfMHRMz3nfaPiF6OKzufrglggPcDO/m1fLxhtCBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728006608; c=relaxed/simple;
	bh=UtWhUKttKepR+eTEV5sh4WYTe5KxRMsisoOCfCDeUno=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Gsd2FQnYBw2ma0115Mfdc967afabR7RBhOgjNGBkM7zXFAKfWJI8VbLxVeLpmvv+v/EXlzEtc67bECdxT7Hljt+Oy2RblU7mg6xj6vvJF2XeWa7YzcVw0nP8OZUtf7lCdDNyxCul8yOrTcytxmlEmfp3Y8NtDj5xPEgMWw0vYsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q8S0Qndm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aeeoZkeF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q8S0Qndm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aeeoZkeF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tegE027187;
	Fri, 4 Oct 2024 01:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=w/NcfFLfRbEVfk
	o+jTinR/JGrAbGFLAxiprpFIoPAlo=; b=Q8S0Qndm/MANnZzkfU2HCjtMv+qCsC
	pleIBMGG3/TquarwuiZ56Ymf+kb6BriKheklWAP3HXcSZiF9oDnncRpLX1q2XBto
	Sz6zXtiCqn6NQOBnh4GvG3jNH/vW1jIQbn/xN63feEkeWVqXyS4nvI4p4rvOld/8
	j872Om02QmPXv5Vwt4S8HWTCVAxSrj12AhfI4pxbUPjxNfUKM0+rpA/bxUvvXV+C
	kSBWFuXCp1hX/AF8SnQJz007ua6RsjoYtoF5qyT5MAxs5IWXLGdlrsj51PgnYvdo
	xPiUiTBjKTNSdXSy/VF2ZGpUc8BIWkKUwy1mBPBEgFYPLsfabIOUtc5w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204grnd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:50:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940U5Mh037916;
	Fri, 4 Oct 2024 01:50:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422056nx7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:50:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UV9ujhpgbToT2prX+cBgKeCV/QcxIPwZce+9t2XYLQg+TwkRFI5uaNVgezakWg8NwFMx4PbLSpLN2a1zDicXW/3s2VV+T+NqIIP/EuMuP8TTR8KgoLLiATo8e/Lkt3hhf+YUVbz4Wk988eFNei7rcDmFPfBjtCtapsNHTfE2CJkVw8FMYFWX6KmJwrycPX1Hd4Zu7xEFkcsKf8vCAE++DXZkrvf3/66JxZDc+V4x1E6OngGMdzrzXGlrnnVorqE2tZV33c7kBAbVf0WSdjwWPXuouyr0iK6ucUPX3BuOzWwpOTE5wf85bur2wKB7eGkcEVSJbbs5GgPdgMc2vOzRbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/NcfFLfRbEVfko+jTinR/JGrAbGFLAxiprpFIoPAlo=;
 b=HxEGdDm8kTeHHbpg9A6BNW3QY+f1CjiDNgb88Hcmcv2L5ddcjK7h+EUxVfS0Rho07B+mz+Vu9VLx9cQVgm+Yh4o1sh1f/szONd9Dx3Ioa6YRlTwgGE/XSP0dfF4mC2s3goA3N6N2igwTrFieeae5xS/XBl/rr6/ZJ2Gbhrd7uYm3J5+nGZQYQXoNgZWLV4WUaYs2aR/3CPavylzBgPyeBMBYJoVbVhlI9y11c9FpGbgcT8RhQJLXi7K8sSupHYnT/H4KAe+wwQb0Ojb8ncCGq7KL+el70pvdDq8CNde9/Rjv2ektdXMgDMEIosQfJ0uqrFbPKkKQFDZ87VVc4m+uXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/NcfFLfRbEVfko+jTinR/JGrAbGFLAxiprpFIoPAlo=;
 b=aeeoZkeFDZ18iu3twqWzNJ2eirmWgYQJ6Ndkp+8NSBOK2j5lF+biW9vGxZjmXee7TbSUqGXhEeA0ggREO2+Y9ly/9uL4o5Nn4Ac6JK3G2o05HQRMGl4DSNcqm7ya5eQjLR7rSo0l5qIQN06lesneD7YIBGX1t7ZcFeiFKK+ozCU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4265.namprd10.prod.outlook.com (2603:10b6:5:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Fri, 4 Oct
 2024 01:50:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 01:50:00 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: ufs: Do not open code read_poll_timeout
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240919112442.48491-1-avri.altman@wdc.com> (Avri Altman's
	message of "Thu, 19 Sep 2024 14:24:42 +0300")
Organization: Oracle Corporation
Message-ID: <yq1ed4w3adu.fsf@ca-mkp.ca.oracle.com>
References: <20240919112442.48491-1-avri.altman@wdc.com>
Date: Thu, 03 Oct 2024 21:49:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:254::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ebf0305-5366-459c-6c8e-08dce416db85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tEyOPuouLVmBDR10KVC0k5YGhgCYg5Zxq3JJhX5QntfPkyRv9naUF4a9u8//?=
 =?us-ascii?Q?J7/WYoMq4lRwohfXGR6SvJcw0a7cdK/K7ltozVoC3aeSvEyAL5fhJgrY8zJC?=
 =?us-ascii?Q?b9T6pbNgEFfILdcGNNgZ4i4Gm4H42koP0BeGcduYyPiaF35VacYcsZMHv1Eo?=
 =?us-ascii?Q?SfiwLzYpeAfRc1oqsHFEm56K1JiezElfW//sreMMuZAl5LxkulomXGTagRUN?=
 =?us-ascii?Q?SiAoZV+kzhXfDfjA8AHfm4uvO40ipbOFYRo/isyR3WNBdHfM5wbw6nfT3uWe?=
 =?us-ascii?Q?6POu+TJQidEqOq3k1igESLaCLW1mfIwnDc0y8wPEk8pmRtoG3hpO4oB1ozh/?=
 =?us-ascii?Q?EVt5QrOR5/RLTV0Msqbw53s8Rxkf7SzqQjs+yqwxs8TmfKCFx7nhHwfimwSE?=
 =?us-ascii?Q?bzlfvoyrBPdmsK4qwf4U++2gNWL3hPoMxjUzwTiys2cVLMMQ4nc/DxIOtPeg?=
 =?us-ascii?Q?bLL8s6QgxxTEXwxCQRezlGUFFBGQbtNd4emW81Ondp2NMgjXUdeFMqIUQ6lv?=
 =?us-ascii?Q?DcMXEI6WVhfch1rUE27bEC+Nn7KpWt7DDGkP5ab00h+fg9fu/u4QvufzCYjd?=
 =?us-ascii?Q?/xsccqM0gE1YBAZGh7g2xorB99XL/CTp9g9sTz+z4NKrLGtiS8J7ySORor7K?=
 =?us-ascii?Q?n0JaJpi/C4ZdBJ/AHMhaezt5v2kegzVMWlgOf3nz2arZ515aVjHuZ7m451dh?=
 =?us-ascii?Q?3QdyEvh7dKLK+uHDWs2ozFbuWzTtecneS0oYRACc6cc4WSepU0iHlaFnaBZu?=
 =?us-ascii?Q?uiTngifCjZXn0SWpV0P4kRbI4pB/YLlHNjB7VPJY/3SQ+wAp8RHG87ta0Q2z?=
 =?us-ascii?Q?oSeWYoPOnM0AaUXCwTvGUbOpjaxDI2cqYt2/WXHIdHszAyb1foj08ZVrKkXW?=
 =?us-ascii?Q?4m0q46yhqB2txSayrtBtSBR0dMpkvvj3QY0A+pqIgj8N2EumpxwhhZwXdRhd?=
 =?us-ascii?Q?9XxCCkf/Nvb+urZJnzCPpeW62SRPN/ORR5+5XKl/ImRULf9SfIjlnWrrAdpz?=
 =?us-ascii?Q?p/P+9wbtRcFrxhnJxALvcGZcGWlR9v7VR6IFrS3w0vQ7paJA7SJ4KYT30Urz?=
 =?us-ascii?Q?VWVHxPtmKuLOfggBMurScm7/EddtHkfBd67d830NGytUTkcrHFA8nUx3aHVY?=
 =?us-ascii?Q?5RYn4ZOoTRGa1YCW+jlSerlOcEq4tyk5uDLvMRSzrzEAiNGJSSemCEumfXHD?=
 =?us-ascii?Q?NsA8+EYdNnft+nvVZPne9ySUNPZuNTK++Rn9Etq88Cxm9BeHfP4AFZsGdwZA?=
 =?us-ascii?Q?+5XT6tXmTEEDK20GjaR8vDb1tIuGfuh4XX5MyEms4w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/4b4ub1P/hClOvDmzLBF00vn+QaQ8lxIwYlt/B0RKwSrqvh/fXdtvdX5RT2B?=
 =?us-ascii?Q?wdofUud6gGBn5EV5ZGB9S+5zG3grkCkMLaRuqhaVzvY5+7zP0cDgpjv+Brid?=
 =?us-ascii?Q?3mE2iFarHszvGs7Sy9wOWgF5M+gdJtIMaZFGOoQkGsWGHMgJ/iiuw2UhB7MC?=
 =?us-ascii?Q?ozV5U/4rPBj9aLaayrFkxAU/SdA+QP+CWKNMOv2yRiOXktLS0tTaAAaVJnxf?=
 =?us-ascii?Q?SSSmi/n6Pr4Uy6mrn+8KxupiTNMJAqqROy/V30QFHYa2JRBP826pXqLVnUGw?=
 =?us-ascii?Q?+LpLMriwDCZhxtRwOhE7dMjOtmRowvmyN50fcAUEHgDnWGIRhOcPcCwUsREe?=
 =?us-ascii?Q?FzDJWHgPPSn9ZD+Nh8HS2bF7LKl47v7whZ52Idjb1H32OrRNNNQeTkVIef3d?=
 =?us-ascii?Q?jBqTe8nD/WAqdu0LKkeOKFVzEuDOhs/UTL5TlZsLfthIhJJLOyhwu8wyWgs0?=
 =?us-ascii?Q?73jZ3oi7lweg4JYDhggqt6K8KZtTiCxyvu7Jfx9TPmpqpOI5OrfhWpMLV0Lp?=
 =?us-ascii?Q?6tFnGd1oRYRmvZSZZ3eeU4ZlURnd7w22I0g3cGHSgzt7bv3HsamtDKtGoBhc?=
 =?us-ascii?Q?2Hhu5untrI4dGAU/QjLjPu+QYUStEKCHTAyZkS9DHOYN4NWDp+wNMe2olco+?=
 =?us-ascii?Q?wy+JSfDrHcYvl1TrF9dWFi+bxmEqgzwAUgVGA2ZJGZxNlKQmmy+Uh3DdrhEE?=
 =?us-ascii?Q?9sml2jUTia5M6xrAOaM1gbuPH+gHUMfL7HvLXGJNwFGnEO87g/xZ5xpcb3Lu?=
 =?us-ascii?Q?L839PI07so8tVu3mX7S0XAccmMq+QjvjcNPN9bkNZMHFqGFUrgA1HrmYzv2Z?=
 =?us-ascii?Q?9cTW4m4nqIESu8AW+5g/UIZ2VAygh6wKCjfNGxQtHTLRtFL4r+12zD5EQZj4?=
 =?us-ascii?Q?JKTu/wr5Lsqe0345C/OHuD4TLqIfSoEUT052dmsitHhgLd4kBLmAsfXbcRCy?=
 =?us-ascii?Q?yMdWJ83VQG4o+Sd2Zty+Ml9iI4DaHzA5MxcaJK1E9WLXMAZW1iNsQDGqGCTG?=
 =?us-ascii?Q?NOZDHLeujOSTNgkwOcCRftbanzqqstFpPrE3UEerGWoyMU39z6cIRYr4s6aS?=
 =?us-ascii?Q?WEPK46o0qQI2S8KA9bTV5ZB7ocUV16J/Sr/OV76L6f6SCncnPt5tbCPNaBmB?=
 =?us-ascii?Q?8BvJYBlCcyc/qTlwuFzq19el7q+TFvObZND4PUYeGl4p0deUHOkWUViHYPnQ?=
 =?us-ascii?Q?VzOIvj7T9lNv1ZgAIiYF4MloKoZvHdDkdPWYSUOvhtha8p7GYoAZsJAwQEi9?=
 =?us-ascii?Q?rVXHtAxN07Xwg/Mo4P1kLYB2+Uydpz5BkWbcJDrd0lGu1M0loLhZD1zYYg9W?=
 =?us-ascii?Q?YqN3M5IGVymsPFEkr17lrz+zO3q3L7lSP+eOBVqvo9NXxS2PkLuy06nz0AuB?=
 =?us-ascii?Q?BRpTZxXU1bDc2SOr8SPoBKOlNgv7zPj0EAOZxe5H1ybfKdrMLO8KOzEUyNdc?=
 =?us-ascii?Q?LQw4lUQmuNrs1RX2/e9RUipG/wSD8H98u/SeV15NJ1o6P7WZMWMUQbucS5OS?=
 =?us-ascii?Q?loe7zM1F9fi3AOkiTfzrja6rqKbGWPU4eXFpm6Vj1Em2mUWaOFqwkNu+24pN?=
 =?us-ascii?Q?usftKU9n8sF3j0bojJoPH/Fnd30EBGnIkzRdtUMQ4daGEX5DgWnL8OIwnytf?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WhJ4lFmV06EGrxu17TEddeXcQVK3CCtVXVnKS2J/5WnvmDZJDG0bTpQ/oZR3dW+cWvxfx2F13yuRcCYvDjoeRnZjqHGLGvENmhTbaC+vYy0O0kS1sR/dtRP+rMv2KEKF5ShPjiygirkZdUsj/e3vuC5VSG9v/XK30yGaHlE+EF/mKLaRcKf2EFxIfkPUYZfO/302y0CA3D6pY81oWY9+i7a/7gh4gsN5FnIPLH6G0NY7GsRZ5nZnSUTUlnr35JzxwCuPySrTeZWcOPUwNx9/4lrFpXvEk6a5m6xy0pGNPMiBsyeqBJUZVB+mWChWQSAQo85ri0KaECpCZaLHXAKUQxmf+idgvIttkfB4/qnk/qxdHM5Y/aJoiVyPFcG8Q16IsLXVmKwa701ojCUud1OdGhZtEK8Xa7mvmYE83fqKnkYG2GVQsq45m4s0hImjaMA0GBeiMPUQ18WuZCpksORhex0oLYlkQFOx+LSG0HenAVFZ/shFgOomZCxzt5CBLWP1Fnc/unPPJa5yvW3pwYunJfXRuX556CtJR8gA/QXTh5vHrG6tDzJp8UplZcnC6tXI0m52Y2mdsEYUeykESYBTOcVxEjs5IPNwSaFCAK/o5Rg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebf0305-5366-459c-6c8e-08dce416db85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 01:50:00.4498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1pkGPTS9L7z90wDQ9s30BOaRLIYlcNI1wgbBXa09YXxkU2SEQWJbeQ3V+Ooj6F7BNPT+6Qp5Y9NycBTYeqxyQh1xSkzP5Jqf0FGM7VhdlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=792
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040012
X-Proofpoint-GUID: 23HOdoQTAKcI4iJSxgUERq1ZW9S_ApHm
X-Proofpoint-ORIG-GUID: 23HOdoQTAKcI4iJSxgUERq1ZW9S_ApHm


Avri,

> ufshcd_wait_for_register practically does just that - replace with
> read_poll_timeout.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
