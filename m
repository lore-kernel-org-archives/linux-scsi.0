Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02E63FB07C;
	Tue, 28 Apr 2026 11:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374806; cv=fail; b=HSesv7lP79InFHCN/yR+5XUukJL+3qPyoP5Wwm7QBGjYWZ4i0nuq3ZG6s4HUXCHdzwJePzIUq7yI3zxvOVSoTzc4RKfLgNf1jSQndhXeTCCb6itn6ERC4IQCGFTa2odt8XlC4XQy0ZYSB3h2wGXhrB+eVpLO24KWXMVeMJ1jm10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374806; c=relaxed/simple;
	bh=NAx3cMhiYhNtsIZi1dbOaWI3BxDz6GK6mKHj6PB3CTc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ooAsdUNS8+hc6kfpFVp0t+FEFVNMyDd/nk1yL+ADMgitIRwUFR/ychy/X8XxnrnddazMU37egNnkYU7uNo184h5+MNLblcIp1tsbDHguPrENpbDq7VydIyiL8upr5Wz7yKjTPO73Tmcfpk600DU78lP+aEXYptVgaqfrqQ9jwZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FtXYoQyB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j561Oeru; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FtXYoQyB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j561Oeru"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9luBg2721997;
	Tue, 28 Apr 2026 11:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=h6mcxHCPmUGNHCg3
	PP0KEZjtKCqyPjqJKVx1319H8+w=; b=FtXYoQyBX61LLdJ9v7sBt/irwf1a2FHx
	FCtA//SC2lLDDBJ6Ehl2fv1CRCbvWTjPaGyF2jB+OHRISfeh4ewEE36pRxWufonQ
	CqdbPqe/OVtsT+0N+lu7FsjbJfc3rP0bWctjByk9fGPHAkQUcDuTZ5M5TOKpyuW3
	6m3WDg1BJzD4S0DWsu7Kl5LOm+i03ej62h3OG4lBKvAC8+heBo0oUeWwGbSEPxd4
	yMZNIC6nbQ+brHg2vzHcsCZ/p11H1nOiPiWfH5ZTv8gQZy/tmcab54SBJ4UrNmtt
	r5yT3SYXJpgkRiiuiube96x2dqIwL/FF/0Kc6goUy+vgydaHrwfEew==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t78fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCk8D030433;
	Tue, 28 Apr 2026 11:13:06 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011040.outbound.protection.outlook.com [52.101.52.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvg0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5SKjt06wLOqzNlDAE9Y+fE3nSQhovtRd3B7n4w2H6D2ZSVMqfxbEbauS1wud71CI25zBRFmnbTp1Lxa5xq4kH3AcKPKAQ4rEbQ6iPyLtGnFnUyR/bF/CZk+EdTAnRvnO8khOwouvteuaxc2d6lYj6R4jss1egnCvwWHz2vQakB3E8moSh8WQE0AX2TT79a4oQZCzlrjbQNdm3anm4+LNZySj0p7qlbfZhlR5GDkwhp0KPmh2UFAX953A+l+Y/57CPx8XcJDAnqttPHQXv0jPmK+/92hUF7V7YLnBpddtc7v5qYhBb/+2hNNf57JRT7rMzvV9lT+IkKhY+sv+GVQkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6mcxHCPmUGNHCg3PP0KEZjtKCqyPjqJKVx1319H8+w=;
 b=LXBBzbVljChqQch8vLIx1H5LB8sfeuu7klNVy0uamU8P9fdMYHSjc6cRfF+Vr1cFqD+6Z3hIppfJmbU4kSGMFThD2ILMsA/VN2zNf/y7Yj6VF5zYrh789G9FFeI6f5d7zOfrbfVTuIIRMKUa09ICcnpJHy/9KMTWwqveseUsrv/P3akZX8AW/ny3SIjhc2a8u8aj2VkWpiPDsNnYSCaBVd/M4Im55PAw93ff4Rm72k7RAQcMoscmCYXmfdl8k48Iskw3hTziW5n7YIoZIlgeWDamJEgQwtAkEFKKQiYFqkr3yNZMvx9ZZb4lpFMVHWWdWhTQfnTJU9LoGlQ02wFyDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6mcxHCPmUGNHCg3PP0KEZjtKCqyPjqJKVx1319H8+w=;
 b=j561Oerupx7UE3MMO5rJnFRXiEU+SyPDopbkQZQAnCRhfGiJRUg4rnxYnFcPvmd2+m995TvQicpNkhDpVhK8Dcug03G0YwjwcLnTwSwXBfRuuRZmyG5Eo+3fXtpv29xndksCcQcYHHc9FAvl3W9MlhAmm6i/GGy4LT70eXSAnqQ=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:03 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 00/13] nvme: switch to libmultipath
Date: Tue, 28 Apr 2026 11:12:43 +0000
Message-ID: <20260428111256.1778475-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132FA.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::2b) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 3916306c-6218-43c6-2d12-08dea5171d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Tn5EVsWgngywCweig6W2en1k613PTK7WcAW3XfLrHUTdgf3kguIojXT6UqvxTlwBnFlHB/6lwn0JmrReTHjUS54IzhxTK2LZrEhwzJpyra903gDpDYaNOa9Y6658S1kWYoWkZUk53yD2gG7qWhOe/vR/4QcJ+FFd9lpCss1S9GOptwQ/sdblhhBz6ibZubEdv7u/UuhvI+INteNj2mEkRowuI3sq1EaI8cIWes/5k9etzDwB8HoZi0NDamVwmmPqaLvx6fYIr9PAyv6MvSepunsNI9hYEcjRMBEB9ryRINbQUNE97Iek+zY/mNI2u6lpl6PrtiQR2SLVdywjckgZ4kCht9HVsQqVu+PnegArgTzmIRC89QTqvInMmEuTWhL2wCMAlIrYZ92gTGZFKW+RtBbg9PHazOeYd/nqeo+d/neIOleh7xDvqtaBLY6A3Xx6inFzIdnL+bqZv/s13zo/X4nIVCSTy1XM1qpKSxVQSGQg9BlLWGgXh2pGpezZp/6hYB/Wa6MN6xqBXyys3jsardAhyAgpZ0ekJJ0dTFIqBflm4GpPCSsNpZIURANOoNKF3R4JC3fUlzGWcSDBYLraxq9dTVHYyszEvvOB40NRPzsKxM6jHWBCUAx0F4YWeox7RjZzDaIb4uFsSpidQdKKaDDpRLOafD7Q8KkoE3JWaZYo41o7E3G5JW7dtxBqBcn0ghAjdtTczsgd4zcheoRPo0Wz4kxyJ8AmV193RLDtWVk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4alLAcr33esbjzoHKtLPliVYjZPoBFbzytsIR4Y55zBDLVfV5sG35dOuORSo?=
 =?us-ascii?Q?7g0ZuVCl7PNenT9QknB54ahnYcfTGCZ8G7SX5nR9jEtCkb2bD5aKytaZN5Ny?=
 =?us-ascii?Q?sytk2eVSh8Fin4RnZmLox45eFGGS6GVLDPh+9oXCKgVm3nx5VqHHYM1bJSA5?=
 =?us-ascii?Q?hU63/iuMNEvwIsFzx3tAtNgxX9SNsIn/jchIfko83R0FtkwH4Kje/oUr87WE?=
 =?us-ascii?Q?cDVS4Fr/ERM23/7DanMPzhy4IrrFWqhy6XZaYKRijAuXHebSNCkhx1A+9MwW?=
 =?us-ascii?Q?dmu5Hh8wJyt2JtbALAJu2SvksS7S1kxXG3twsaco2TqTsnlvo6SoV4Fd2j1Q?=
 =?us-ascii?Q?8fRlkKsxGB6TAw79Gz1WMuQKYrdyL0Y662y72aMHyRjkcWh//hdnsCekECbh?=
 =?us-ascii?Q?P0Z0Ya8vDXJ6USplOyFvKo6dszG6Xv8vI2eXs2irz1F+zjhTdFXv/SMGlp+b?=
 =?us-ascii?Q?SauuCjMw0O2W1LeAfsZKeyJ3xIzUV9afvTmhkABfPlcSlI4svO7VL9XjJUwM?=
 =?us-ascii?Q?ZOnpIWF2fi7rTr310fxf94r2SPKSGA44K0MyBy5+iBD+nokv9IUBLoaSza9v?=
 =?us-ascii?Q?T428ZGBd0OYQyyvw0RN6OHlUmnW8HXqVV2clJl4tDoBP//St7xuvX7bg2mq0?=
 =?us-ascii?Q?bH/ZvVtAe6sCu92Tw+cJ2A2XNm2ueEDDabjcVA42+epnLAOVkcFBJ5lmDOqq?=
 =?us-ascii?Q?BFPlDQ4b1p0lBcGW6ef630l+1UTQeJT2BLUUIwCoSDlVG+wva9c0iM4QGMDS?=
 =?us-ascii?Q?0Ljq6A607MjAo9MU0Ct/dIFuRk0eXsQ5Ug6dLIBSNkmV+7hCn9OV0dHp5bXi?=
 =?us-ascii?Q?QQmshHv+7H0g80QPuPAonrFWgiQZxH6dkDBKRaKbtgQ5Ys4aORl0nfMm6PTm?=
 =?us-ascii?Q?JkMSy5aotiqo1ln008ZO1NKboIBnoJ8BGTlFwvpdrUlFME19WRFRCrkMQFT3?=
 =?us-ascii?Q?ASgVR3ehB2WyP/56AY0594HlNIvHI20PZajFW72eqSE3MkTUtEt1jLg1x6z7?=
 =?us-ascii?Q?cGwfKlihZOrtMibQohAckAXB97pYxSKM//6UOu66jxT8T2uzYoyAX3FSVOqW?=
 =?us-ascii?Q?ehorOxCCy2h5ckL5dtu4a+KWf15tK8hF4mJWPa8ktdDKNv1QoIt2FEagcwF5?=
 =?us-ascii?Q?NTItfirS4DO2GR/yI3TlAkCl0ybRAYDRvdDc9tV3NmaYxvWpr+gqx8Ef1v67?=
 =?us-ascii?Q?5IIzmDuaqJl0ByvhdtgxtCxkLayv6jJUd13K4l+HuJRnoscG3QUINB7XWSSt?=
 =?us-ascii?Q?UpzJOHKkThO8GpmVEXHwbrv4rpYgrqfzLt+YGIPPGzVVzykMhN6fVpDUqmAp?=
 =?us-ascii?Q?GwKntP0ClBpppEBEyIleLONinZATUoEuqFtBauA0i97NDjmiTWmZAHHWg6fU?=
 =?us-ascii?Q?pEdE0qSdo6sGzhfRAd3XuABHvo0RiEVs34UkCQGw4t088yFH0811+ZdXwmGp?=
 =?us-ascii?Q?yfcXOgUhoSmuqzpvlvv54cVc0GX6/H389a05pl4RRaNT8hokE6jtw88HFI2Y?=
 =?us-ascii?Q?e838uGzMEfaYUDqflDtCQMWaZ16lLA/TdihJ0+MuLlHh4vX1gprOkQVrOxqw?=
 =?us-ascii?Q?Sa6Q15xGNnd+8dFjPu7K0TjFUELo/g2le4d8URc/iRpW9S5D9Hc6JIcu//vp?=
 =?us-ascii?Q?7Q0oPi7NrrZpT1ysEyI5HH5DnpHPlaGzZ+mZ0zjvVAVrcx7wnTjooAALLgfn?=
 =?us-ascii?Q?jvULfhux2B+W/Sv/sZLXsdqdGJ9keKZ2kZcmxpzHP6Fd4+fXaXTvJGzqrFtH?=
 =?us-ascii?Q?Hb3getTobAa+dBrkad3zF/aDKNEea1c=3D?=
X-Exchange-RoutingPolicyChecked:
	qYV4a7MAfQDM9tbHzm9nrz2V3bMkg4w7gkuKhkAcSMqKKEtExackrntEdUAvFylyAIWI1ayufLbIeCnMWWpI3MW2tGsu9B8cHC3OWJpkM+EXtGm/6f+EQ9ka8d0keofTkARH/JX6/9obGXcyOAgD5fynzPVsLcxfp6+l35YAb3oO+Y1N1nlpuRDQUHj9KRfGJT+QJ5h1Yuh2RDU+OJ2XnHLT/CppireP6Je4FrabURfl79nRLcU8DrrLmHe7lnKXoHkj1EXL10hVnUREFeZxbHh/qida2fc6U7gOhvFCgwScyJQzu9ZWL/jEfXfI84Kk6fo7NvNSlgvv2tjBpS+Ytw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FiXKdvVFOYmTc9s+rkEayOCTma+46Q165Ats6UWnXxqkYuwsCt1Pj8YPNGAH4GOZ6rwE1TMgjjMRQBfiO4OYXrf8h1pwsQZpKbD1DFP+7RmhpSiD3LKVs2rlxmq4JHJ93ZuKZRiyKutML/0+DwXXNLQR55QktHkgCODUNd5b/BLjaixvBv9+P0ojlMG3PmtB+cygZsBzxGBUOqdlWIfaFa/KZGpHEYluRahYKF/amSkCJtv8NOil9hO0OXSxzg0ZQtm3GXlqGXGNVYsHLgMR5t0sxBhu8RynSEU4li1GEEP+rKINSWa9xj/SAJbxQFRb6nlVR+nUAJRQBdMZVIv/YmDNy18rUuU57qXfSc36F7AXp6DN/4GCvGz2CWEVjjYRh4iXuYhIGWhRcFzJnAy58L493B1Yw8Qp6L9q+uv4LopxuhHtxE/3Tzo+I55WVw5AUCagbzAVSKjZxx2oUvOGngDFme0qeNmqU4zW0RSSQEyy5Ql5wZg5ltED5e7xxu1cb/UQTzYSFwSb43+AdfoSrHS+0ia0p7DEFHcZg9K1SPkqOouNXfJob3JAvKo5Q1HnK0ZVGbQhHsKTUkuZqMD960vBxZiB8rxbr0toQ3Vs8l0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3916306c-6218-43c6-2d12-08dea5171d57
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:03.1114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53EYhsi/Xd9tPPA5BXwwM3ggmsF8n0dWJgC2iy37enM6I6ZQnlyhVq4v7/+X2Hm0mCCWfaPKZERqkai6jpEVow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=840 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX49lRWWaEJ1hE
 dVP0UaOP12aeBab+PZ+jJCQ5M7kdsJ2y7k+oGPCidaV99HPvg9CNMKuK1eIXrTmYUfWQ3zw1RV4
 ewNQCtk5u8cBlkidhpd5jf1V1SWsLG/wospNhD/WAThUdU8GZIO/OaIrEhOzrNSBEGN3JCyl1VQ
 rU2rB92BKWXm4LsEH2t8pHFH7Anm+tXFJnBWBP0G0ZgkXCE+HBGnNTJRc70VHwGYC9dd1ZSzqEa
 SjczCUTcXBzcsUsyfSEaJagmsTp5b9aFWK8mMzPsdGm2kWZttDYKXl8voXXd8X7RcUie5knHHyc
 o7kkJ/APa5V5WZxSV8EjkFjYHXw9/oRPUb4g1GW7McsyGFDRN/hSQCmJyshuV+NCZq03mRD/yRP
 oVs0M/c51j1j1foTwV9Z9GROghpGl5h1Ifv/lw+UE74rMsxWnOC3JCr3sn4eyr6DcZt/FwGM6MX
 76HAZWNtIqUExIRtg5Ztdjovd18y1AhYf4YujptA=
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69f09643 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=NEAV23lmAAAA:8 a=4sinxeGifeqcQ_2ykc0A:9 cc=ntf
 awl=host:12310
X-Proofpoint-GUID: o9f6nTXQ9dqs-4WKWHi0r7NT1r3K2LyM
X-Proofpoint-ORIG-GUID: o9f6nTXQ9dqs-4WKWHi0r7NT1r3K2LyM

This switches the NVMe host driver to use libmultipath. That library
is very heavily based on the NVMe multipath code, so the change over
should hopefully be straightforward. There is often a direct replacement
for functions.

The multipath functionality in nvme_ns_head and nvme_ns structures are
replaced with the mpath_head and mpath_device structures.

It's hard to switch to libmulipath in a step-by-step fashion without
breaking builds or functionality. To make the series reviewable, I took
the approach of adding libmultipath-based code, which would initially be
unused, and then finally making the full switch.

I think that more testing is required here and any help on that would be
appreciated.

The series is based on 8658b6054439 (nvme/nvme-7.1) nvme-auth: Include
SC_C in RVAL controller hash

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-pre-7.1-upstream-v2/

Differences to v1 (apart from porting changes for v2 libmultipath):
- always depend on LIBMULTIAPTH and drop nvme_ns_head.ns_count
- add nvme_add_ns() and nvme_delete_ns()
- init .drv_module (Nilay)
- condense code

John Garry (13):
  nvme-multipath: pass NS head to nvme_mpath_revalidate_paths()
  nvme-multipath: add initial support for using libmultipath
  nvme-multipath: add nvme_mpath_available_path()
  nvme-multipath: add nvme_mpath_{add, remove}_cdev()
  nvme-multipath: add nvme_mpath_is_{disabled, optimised}
  nvme-multipath: add nvme_mpath_cdev_ioctl()
  nvme-multipath: add uring_cmd support
  nvme-multipath: add nvme_mpath_get_iopolicy()
  nvme-multipath: add nvme_mpath_synchronize()
  nvme-multipath: add nvme_{add,delete}_ns()
  nvme-multipath: add nvme_mpath_head_queue_if_no_path()
  nvme-multipath: add nvme_mpath_get_nr_active()
  nvme-multipath: switch to use libmultipath

 drivers/nvme/host/Kconfig     |   1 +
 drivers/nvme/host/core.c      |  88 ++--
 drivers/nvme/host/ioctl.c     | 108 ++--
 drivers/nvme/host/multipath.c | 897 +++++++---------------------------
 drivers/nvme/host/nvme.h      | 136 +++---
 drivers/nvme/host/pr.c        |  18 -
 drivers/nvme/host/sysfs.c     |  86 +---
 7 files changed, 337 insertions(+), 997 deletions(-)

-- 
2.43.5

