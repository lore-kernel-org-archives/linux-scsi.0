Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE9F470EA5;
	Wed, 29 Jul 2026 10:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322357; cv=fail; b=HOZ9Q6c5j9QUuzlPJa9YqIRav01b2qkZx3BiX073dgbWS45AC2V7i7TIdyyX1uV7cgR2MTnjpml6p0jr4V+hSbF1FU6DUQNj9CS07MRrPze48JKsD6tDon0nMDkOGDaJH6bOs5wgzJvjlFkbKoQIii9o55yyjsPbPwml0BUxHVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322357; c=relaxed/simple;
	bh=YviQqDeyGpSnItm2CHIzPZUoX8QbYJXYwcfuvJQHrwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZP5Z8SWOAPneH+XGuZpoAUnxEtrNRgvtSAVDlZDcA+kyerynrLSZGXMjPIP42X+r8tgYhgU2xowMxowrIY0kKLaibjNFMsWfIQEqx/fsmfWb7a6HAy4UK0dfA8953gxDGg3Nj5WMtHDgIP9rxgHz5uftQS5ouDVwWAGIqCxKrfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GJXDGBAU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QSaPAT38; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GJXDGBAU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QSaPAT38"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9qkFN1279343;
	Wed, 29 Jul 2026 10:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ivH25svXlslc6tLVkzMKfYNxi1meq5Fq+CMMhLNglvg=; b=
	GJXDGBAUuiJKZbF2V5gAXv2Tf0CQdZHAhHH2zbKD5eRF6hCM06gihlYHRQNXgmEm
	D3E+aUrx7W7fNIU2Htx88Hf9pD9mbHE63Tqpb8EjkrBc4aHkMcIwpCzkFrm2kxeE
	ITwIhS2RZ3+XNPgaX5WcZCNkSmR0+65VrLmSHMwXg2oAb7QSh108lCjoX+zqScN2
	OTF6PW6uljn3GNS2K5Vb7oyyZkq1n7UzubTozfgIxfeMVpa6fDg6kvaqRP4h3PX1
	2aV4vlCJlkCabA4fRKcpv8jEbGgnak8DX5FV/Nyyz0tDMaXfb/xoJ8XF4t03mDJV
	uyscjLSGMy58liH48rPKjg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pnmxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAoZln005050;
	Wed, 29 Jul 2026 10:51:55 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010012.outbound.protection.outlook.com [52.101.85.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dt9af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSOCbOp60OYyGvldXeW+H+/OFqBGd+ff+gKtm6gwBwXpNHrS+Q1ZylDHNT8xGK9IJJsrvFsVBe+eKt/jyi2/ZVzKGXEKL2nxexpfaqsMlg+mOGZ/pymqIGP8QclrzM41Fr5EVYtLfB1mqiQbPLFgpiQoaob9dSwOdc5+nnLmnfFLdeMfVpLKVwYS8mWEyez9STeOINOMU7AfpjhwFJro4pxUTF/PrsheVB7nzRaTsU95gIVp/A68EOs0+BqBI9x6+FRI9DIdOdFn+iXN57Xv3lUFuV4YspGAt6oCeuNG7Rt3GzPq4yS+dBledoj4djOqUL51t70pH2V/wrLdQgiNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivH25svXlslc6tLVkzMKfYNxi1meq5Fq+CMMhLNglvg=;
 b=E1GqgbX6Yh/NBvoPI4hmndn8sGNYJL9QcqVXDx6Cyin0lRm/qTMN8kWGRlHAY4VpPSuMIyJnz+KaoxzSndjLBr1Bd7dTH569Yw9IUwBjM9r+HJR/fhkxn60zamJMGguePNuAmbGJnCtCFyeAo7jKGY2pBmhYR8BtQo6ABcWWm+RAKk2Hy7uCopXq7bYtC8mx42+vz7lKmGWM+1GW25uAkemA93nLkMcK3DIlcm/VQept12L7FXSH5abUtNrSBzaXkeZH+6GFJ7GrqzUtQ7VMppglpiUiaRM56E+6RJWS5ndmJpZGYeO3wtxTNOM8HtHCZaZpg0cx4eH8hfN0Md1XEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivH25svXlslc6tLVkzMKfYNxi1meq5Fq+CMMhLNglvg=;
 b=QSaPAT38B34/xX/SPxhdqIyfGJTd1BMS3ia24tOmQMWjcV3kU9FJVlUtF1hJuwlSmX0IZwuu0D1bLKjnwU1sF1ZOMZnBXX8+deGYNasqVO11lq90skCENs6EZef/D63i0RYU8FVDP2tFcEADhUPpReoyyxeqUzGlFL3cWSLAY34=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 10/27] libmultipath: Add mpath_bdev_get_unique_id()
Date: Wed, 29 Jul 2026 10:50:50 +0000
Message-ID: <20260729105107.255712-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:510:325::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 75231ffd-5599-4c43-66fc-08deed5f656a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qbIp9Z33U1akxqw8ri/B3/AkJCd0IynTWUNhXX9dUlxIKObHqbSd0LMnV421qw/5qmRtfhfDs2WhZvf+5S1UTfOHGtBA5Xc0Bg3AL8VZ9fS1CfItN0Uf93E8UOkfsrz1GaWco72VUoNa9kV63MgkuwRYNw5Buom08lh+n6ws70epFYChSuj1cdWmKPapG4lZwAjD//Dptl/d1Ik10UR1el7TATkPkQzgYzHabTahO0triWVz5nbehfyaZnqsBmlyoPAuekLmxvh5ZqZEeESfTGUf4+GyEsBoMbDye0C10Pp1f2l9hKgRojgIVp/+Sy76QXTp47KCChrJltKA6g8ZHwF5Nn6Jotf0ao6Xxhth2eQbo3pcgUHiGl3Vmrz8J2mpPK7McbkT7IaYVVxyYugDYfGt6BfUtRiqNFJm0vHpAHTtYUtb64KRW/srB1kKF8y5j4+/K/05GlBgLIKu0JSwPFTD8fRpVewk70QkVx8u6tWGkUZwy3yzbXUKeQEocMfltGl95aSv0b2Y+2Eu6JmUHGTO0nXVaTdeo3ndzuTrDrQ7yQYSrrPrFzi9dM3o4O99JP4apZij2azaB3fjMyOabvimliyhZT461IVtxlWRPwLrU8NbtGXCuWPrnsL6fvZXN/D4Y6bOsD69QsFkunI2UcpWnrAANm5VuO95R2spXMI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0mHSRTUatdnbW2Ygvn6m9IWm263IVSH6gXwznB5wQRgmO9DurXaD558d6Gys?=
 =?us-ascii?Q?jCE4t2KFdeWUxUIZC0nDFEPgXAc8CrBY9e40wyqzhuRJik9nRNYiZPh/7KFR?=
 =?us-ascii?Q?y8QGQpRK2eNul0VFMm7AR8IoDhFliThwm+cav8fsnzrWSOF+HdGpUWfXJfs7?=
 =?us-ascii?Q?QmSpybGK14p1Q703iuqzz0N7gbMUa5oH2s685x+l+9zTfj57tnfe9/VtBiEo?=
 =?us-ascii?Q?biwkssqPJUlsCap7CH+gn5TwYKwSsSlPM41X/K/UkCGvgMmBNGcNKafDCtmO?=
 =?us-ascii?Q?1CCOixNkoJNH3PLMvUpp/HMiIQ7nVN/I67Jb4iC0oOmurB719afBODqYDmP+?=
 =?us-ascii?Q?oBliXen6T5Bjlvml4kIQI3MXhE77QVSJab63dXImxrwjH5ziyMR1qMVFHDMQ?=
 =?us-ascii?Q?yR/9VcBBz3JRLaYr10YcurUMLyQ/in4wGerpIQkdsWAbouqBLFa/2x2hH02k?=
 =?us-ascii?Q?OiusSAQIDT+fzxlCtXhOvvuDP6wizJzE8bujf9J609FU2Htx4dw5vifXC1dA?=
 =?us-ascii?Q?z5NYnVMpS4rlO+QhumC+h8DnassivocKSVavZuZKhLQ+snhm/SBHnVG0JOC0?=
 =?us-ascii?Q?xmrpwWYOR12lCvErFIV3VVH8tBn0EHzW0bbKhFgyUvOw0/fSzG36RNW+t27g?=
 =?us-ascii?Q?4dox270WcDEdTJlqzk42K6dl7U4qr3j64Xput1c7SB69zOMoMvDisUIwpY8T?=
 =?us-ascii?Q?ajn/4W0pYqUfkacE5V8j7F/ujm7ScT2lwTQKhX1NW8N3aGm/Wrs0n+DFKHK1?=
 =?us-ascii?Q?EYBWE4cyuMsseKzEujgeK51bp3V1Jgz/j6oCWddPis3Hy/xMKjpOuE1BasKK?=
 =?us-ascii?Q?zOziPObVDnBX3n/5gaqwJZcvalFa0XEdemyNCAIeIXfUg8A4qJsfAFSG4NPK?=
 =?us-ascii?Q?w5NEvN2pKr7P6lo+XpeGU52N7L3iBPxXTzvUlc4spFfbmvuTyvUMszeMD/i/?=
 =?us-ascii?Q?zLre7V1N/yQPliOHdT5Apk1MSZiugM1aWpVH+e+6/L6QcTX4uWzh3XZh3Iqr?=
 =?us-ascii?Q?aEqrVxL2FMD0H7M/aGSzw0FdNO9UAkir0gm5XHgQjQrWZq9er+WPtOvhIsdt?=
 =?us-ascii?Q?WP11HaruJsN23B2tBEsz6ALlHDLd2EwmfSJzQFjv8pG7Xnc8Dl+gc7KT7iDH?=
 =?us-ascii?Q?bQC3XDWv/xkmlwcLE8ZW634pXVf/60zUbx52GioqYHWag79DhOU+/KA425B0?=
 =?us-ascii?Q?UVNpRBgfz3aSnq0ZQs9W/v7n0Izg944D4LkzLsfaQguKLH1d8qqLs0FTtcE/?=
 =?us-ascii?Q?EREEm/1FGFD5JNnH7qnel1bHlUG7dkhujFPrVXEfUz1upodhpTlIZbe56+PJ?=
 =?us-ascii?Q?hPHzSdy3k+fgZiAE/XMvgTvE2Xrbj1LpwPwT8ikPa2ouBxCl9MQMaWpnedyj?=
 =?us-ascii?Q?D2IW8PL03/yHoiEKhT6ePuL5s0A7AT7ZNWlLu/mEjIcTuDMDNOay6tuVNfgn?=
 =?us-ascii?Q?e0oZ3QiBbJL25QIxoTm0mH1zBV3UsKTGJQ34YUSzjTIhmVaEot1NUsLoR/1S?=
 =?us-ascii?Q?44Wc+zjb6GeBuiSHRKH417V5Y1xYmM81+orHvY5q0uiwO2yiZ+h67ht0bGzi?=
 =?us-ascii?Q?pnNIPUg2AGWs4EP6ubFbLjnjaTW/ZmsPixtdX11WZWRaMYSax+8jFgrKMWIz?=
 =?us-ascii?Q?NCAFxVQvYNGaTCH96K3gOtXqKFAh9sYtJlG2O2IJWwedVrH3Sh8hJwk7ZGPA?=
 =?us-ascii?Q?qqw/8IMMsjBG1e+fY1XgcJibLHXRbdr41tyWmNdjp+/Bha9IBae0kpwrMBrB?=
 =?us-ascii?Q?2WmsBzYndw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	ddbEwkHt2UBJSZcYf8122FvM106oh09sijA09IyDBGceXwPtLEOkQtmmL63hV6bwlxRJfznpL7aOSFkzpRwXiuTa+2UaaOTnG9zoTkcETyp9/aNZEv/WsWfY4PntV+qUZXAcKBRrFWNAimgcy/1DN2XGBibsaqi2dcbkKKlMCeQQ74exa8EVDn+GpaYsLO6iNNa0WczFfLQNpM5wyfqVBq0LFKTfj/Fdqwp75PewkpedG7uNgIXak3ii0XN+g4fOcV8wwJp584EJyU0qYSvWjcNUWzLkHwJBA00xoBLY2PnJ3CFngIoFVNNgJg5w31pzdt4FF7P3lpL8dAbMf3ZjGg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XbDsKBv7GuZ4UpvaHIpAKlxCzis4qIcHZvm8TK75tvFvk8r5JahmGMXrERLQOFITyJnW/kIF/WLldr5XK/Xk9iFOXLUOtYSi+OI+3LSYWf3Zq6Uk4/Gejyw6stRNK28BKgFY045m9LHOa9XO3h9r+r+LlWtX9xSGUNPaqdB91XbK4ODHJfSTMzXFoDPCZcAOqGFpBCt6PM5CvhxM9vC0yIWJwm6yb/LBFH2Qy4cJLH1UidAeFTfJ0BHpUs/RYiWSqZW63QEwn0PE/da0ysvc37nTyNxuYymNjcfAO7BYCUHGE9UEG4P2KDNYH5Ggs1iVU7iSbjIozQSzBLS7PcmB3LbYDxHL8NobY9hPqfBhadiDWWTWt1XZ2g3jPtja55PWn+Mxq/Cgv5nRbVkTsoUPgtU1Bfc39xj5eNta6ZkPrECN02OiChHP1sjD5/2ZbMaE7hDOc///XT4EEP2WV6uJ2IEP8CWVb6CjQRwGWF2PAApLhBKO2aGYb30EDfvCfpGs8tMkCgmXNuOiDY0iqAIHn9avdUnT9W+ktR+06ucSaVanEuDdBZtc1JWNOCGSDFx96Dyi+oJiFWwtdgeo3jnaUKVF4M7yJKIErBOq+Z6WU7c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75231ffd-5599-4c43-66fc-08deed5f656a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:51.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SsU1yhs22NOXXknPKapQH+n/qkQqPB2RZa7OJI9CtAWY9FMz6bNvnB5r4ZsTLSG0IxK/MYYxdV9R3w9huaeF3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-GUID: iNKZzJ66l6u-htNL6Ks6pvoIHMavWW2Z
X-Proofpoint-ORIG-GUID: iNKZzJ66l6u-htNL6Ks6pvoIHMavWW2Z
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a69db4c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=wdrd9TenfaMKdVnI-z4A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfXwtvRTQRyyl8U
 3unLFTSXwcikBSRjklEkO18mGEQrSS/pDzgHnIH12k/f7u/ToRTruyophNR6fbIGMCWJXEMiuIa
 vupaD7ho8AfW6picgz+OOzDBMEVnwVbptmNHX7R1SwZsvK2EGoA94PZRwyLTS7xbKhU46JhGOzp
 lkj7FT6vXkPbnHzfRdQJ7JCc5SYU+iWqZvcdFQ0l9hNlRz5TcxrrVBsLsaRRGzcpbZVofI2eNgz
 o0Ivf7RcU5TFoelfnCjvjpjyiqJgMfWgxV1eaZvyrsnWYUeL0sEiq2bfvMmL803EZMkY80wAN/j
 TudveD2C4omib/B9LUvkrDbtq3/1gsjU8wHUW9nabSOclHyaja1OjZ17Rr+BKjkJ/gyNrOxVNxR
 uxcpzaIETvWxHXueCJtpjbR3DhISJR9FxpcwEVVA8ltcWLp3o6qx2BRq4yrPqVIdiqBrMET1uHF
 SbEljav47GPvXV4E6G48uK3ZnnZgvSIsA3yKF+cY=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX7tP38MIIdjhZ
 s6UUQqGc8N+6F0i/yQ0VnItE9HPhss6dkXQkrGcDGiS2EjR7BS+fgw0ixCLqQsm8WQwJNNvg1HM
 H6IPo7v97wQz8TT+Pyq2Zvlrw7xpeVakrUCts7NE+D0ufOJlGHVW

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 2017c4d0a210c..66b3338cf8389 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,6 +454,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -521,6 +542,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

