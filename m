Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BB62AD0D;
	Fri, 10 Oct 2025 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105744; cv=fail; b=Iuc9qPZbXqdZzDS7Vfmqd1rExV2CtDD79D9q27psKY8c2O+oKBDoiTJawu2W+ubIesBtjur0DoREwylHohhdGfR2s1vYF/zhOqW6wwdRA680LgGu85HbzKJNdxpdbnG7vy0mlp0nGJLUVOu++KSXAB1svmsMKQNCU0Uxyu/M3+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105744; c=relaxed/simple;
	bh=7q7fvISRHlOSuaQgGSsmw74aASZM7UimU2n9zoqt+Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mYldSYsfpvxbJXyW16b+iBgHa7A6JPFykee7+piwjCc1KfornA0y2sCJZYXbhhDqMWD5lxCL9+4X1ecd5tDl43drcFThedo1KidE+MD31efHwveck3damHOzzsK1BCc4MaDxN8MLqtFXkp5lPb/OVKaVKMl24bQqMuFvxUW94OY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=caX40YCG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CoR8Qlsq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="caX40YCG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CoR8Qlsq"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tOqV022802;
	Fri, 10 Oct 2025 14:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4CBO3F99vxG2oSE5QjvWJFrskOyDJ0xkzF1EfyyOIgE=; b=
	caX40YCGbeVxzv96UEHCMl80HWtxOHht125WsrGGC1M5QCVYDOQUVUVH9Y6/WH2/
	lNjIqs3FdXxzQSssu+IeLGS0KBdLTnxtDRtkJSmBH2iIQI+5zoyYdtrnZz5JUNrU
	UUCjQl1PJCiwIhbf1qj/sOM4zCHgU0EO3i1izpcKULOr+0AuIsukO2ElFWIzFW9S
	JOc+JvHIKCgkDWS+JLH6JCorpQorJ5/Ma2hT9oJxr3oePMS4yRtFK5C1lMilwR02
	SrgO8gC4yRAVikiBJdZAThzySy39JzP/JEaRXjafRCmv5yWqTGOqML43gR0xVhtu
	j26VlK3c8uLbTMPoumbz+g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6bbu31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ADq3k9014463;
	Fri, 10 Oct 2025 14:15:40 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49nv68s3bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SCJTxhhAzBTOA+V8phhWlNTaoY1uOOU0Kc81z7LkyrxsN7rlRwHWDCGN7K6ht8U5SXY7WZaVE/j3emWny8i4/AGQPTOtixS7BRIA12O86MaI+WwuvXK6RNOkNXgVFXVNehy5/MsusOutb1D5yPd6f9OIWVTiAJ9eFM+Yez+xE/WUsHDQaofwG3R/qQoGo9JUj3OygLA+7N/EAv4v0/m/2LHf2R9G5GUC/LOQL7PwEMxAlbXjxT2Aaw/hpAFRyMi2e6h22dt1uFpfMjgpmPxxyvuk01H436bu4EkTWbHF7ZB22BvdvaMhziH2WmU/FQKe0gOOPDqJ8ZK0vzV3H90rPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CBO3F99vxG2oSE5QjvWJFrskOyDJ0xkzF1EfyyOIgE=;
 b=MVL3jc2e3rHFWmVNanyH0qjhgZUzakShQOXFf+lJdizdJkl1GhFX7OtnYUKF8udIaSBGHsOFrlChLoY8RLttpVXEzluRT9YEe4VoQSKbvsM/FxPk4Xm2h8+nZcGA3E3V/6MYPAWIn0QVe41YNEDTWIGqy0hTvN/TP8KSdTWnW1fqOEMrB3ztdZkk4SHqlPo8hao2mEgGrmlIRlriA49X+B6fEO7fTxSdiUMqYWyVJrc5rfJruvl+7JI+9Gu2bhFCDdcx9o2pDJcCRj/lWM6Sjs5R+TGhf4YoexX8zfaeD4PwHCWuNXeMKDJcU1i1FSdE3y4gkurncg1L8AAfky0hqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CBO3F99vxG2oSE5QjvWJFrskOyDJ0xkzF1EfyyOIgE=;
 b=CoR8Qlsq2wdP5tpTMakXdiaKoR/bgohqUAyd/zAnQl4jBKKePdTuYmi8HF77ynUu25yumgFzoD5qdUnURxU4aW/TPpY++6M3YliNNJr/lRJO59ViNd0EGI6pzciaC4//nIxgPnyRelrj/wEcRj8OJPs0IDGG5acK69b7FtxOcA8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:37 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 5/7] scsi: target: Report atomic values in INQUIRY
Date: Fri, 10 Oct 2025 14:15:06 +0000
Message-ID: <20251010141508.3695908-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0025.namprd21.prod.outlook.com
 (2603:10b6:a03:114::35) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf08bc6-4cb3-4600-763e-08de08077ba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S6oXIAaAepHWa9uQt6SJkTtzLwb6MztyzHR0Wk1/ZgEsngj50fULFJ7chF1i?=
 =?us-ascii?Q?Asm3+6PYjhhQMgQ/ff2Zbl6tVdZbf2/Wn42KKG89bzsoeEKWBWACJ0sCOFM0?=
 =?us-ascii?Q?Nvjc0WYHWBMWkN3QSWdUojdQw+P3YUAv5YO5D0EpGIBEeU6Y489Nl5PDOAHW?=
 =?us-ascii?Q?0U7H2RMgFXMj0rV9PWU6L//iNIZxWespA0mFcsYVykDkrstHMUurheWnWTH6?=
 =?us-ascii?Q?ZOgUjjAnT/B9NP+YyfJ54SyBTjqaQpNAXTANJZjy8wQbgC1RA1W/xmf0Ukku?=
 =?us-ascii?Q?Scu+nCWoGjNQi5O2T+rlS3nsrNer1pkS2WFibkdkEhQB5iJEa6Gto6w1iZ7q?=
 =?us-ascii?Q?+pBmGAuqD76s2btzjCE92365cQ6bO1aPTM/2ohm/z9X0zGRmXUfozzFMCChn?=
 =?us-ascii?Q?g9XkZdkSRWUA1TTxTPJz7Sw+HCfecxfOaXz0c+vYhwmhO5jlgMv9iwllDOFi?=
 =?us-ascii?Q?40UoNYmSM8TVSAastUVk0uW3PwFMnPxenHAJzU5SiPE965W6+kYiqBd2ADnh?=
 =?us-ascii?Q?nGUrlkNP8CwKHie8Cqn44UKFy4xPu1j9TBNF7m8U+d8yN3XoLzNzrfUKm0XL?=
 =?us-ascii?Q?MQc7GEm3emugq85FlU8L1tWq/OHqfCPzuoFsaWSpEluT7XGydDt0fvxo6SVf?=
 =?us-ascii?Q?F+2w5uaTSJc8KQCtelX762IqIDPwx2kVbj9ZyQVpxj110s5HZOsH0eYoDIIX?=
 =?us-ascii?Q?lWCKdRt5V+ZptB07Rzbpzis8PE9CKauorVb/OW02ecBZwXVNX4pi1p7JFrN4?=
 =?us-ascii?Q?XYRr9je3Vkz7mSD+D0+hKRRhEzbczxmeF6Sa17AemJ6M9JorJJpErDTcT7OM?=
 =?us-ascii?Q?lNsjdEtwYHWWTa1GDwEwAdwF5QblN6XML+sCnWg7Vpso3+m87huFAHFB8FO3?=
 =?us-ascii?Q?eh5soGMjB6l0I5i+4P2+OaqUYiZ4XIUcxO2G3Og/OwZ3tW+8QRaplT/b8qqw?=
 =?us-ascii?Q?QoIrXGgcpyGGYa2/l2qgFc9jfb/w0TX7aBRezubUGWdHK3ENa2IXRwUZBQ+5?=
 =?us-ascii?Q?TFP7Ief+253MaIFTU1wr0r49Dv+iZIuqb10olsSVfvPXD2mclgPY6VUOZJ9u?=
 =?us-ascii?Q?GvNaNUX2/NIos49rTt+SUp5+MQ27jFQNgFZNUaiCdpI/E2AOAvT9GSG5uzTB?=
 =?us-ascii?Q?WDR4T+lQv2xaLXjt7YuSbA4TIEhaWuo2y1/WnQpu/LQVtRLKpJPTIcpcpL6m?=
 =?us-ascii?Q?kP2+VUhrLYald2dRx5ALA6Bl2/4YiSRKX8cXRK61EjXgO9KRG+8jkbJeaxij?=
 =?us-ascii?Q?D20F2kw/9D1UuB9KZCIfl1nIMJIu88zNsNTytzuj1MynJ8hcBMWhWWJRpBSG?=
 =?us-ascii?Q?rGDLzfHToJI8hm0znBz7OrtAjySTNbgsx0mbLjtURvrPBFVXrBLJGSWUYozQ?=
 =?us-ascii?Q?d2C8xgYZv/oeyZ4EyxjmzT2NkLv0XWbl1NnLAGXJvWZZ5uBLWKx4cBIThdcq?=
 =?us-ascii?Q?ouRPVdIYAlmik1b5m3sRq1sSYZhrJilqQ65+FOHfpp84OFrWkB8yE7m09Yey?=
 =?us-ascii?Q?gz9+2schyplhPSkzCDKfEEY+ovaiUHtRDqlJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PGmImWv2S3h90J9bhxHBwFRxTRLVtuc6XX07zTuyseJ/nbPSEnPMLkADiPaG?=
 =?us-ascii?Q?/GBL/N7Fll74Zv1zt5ovPAvS9tYDlI+S7Bncui7DqCvqPDx2lv/jrHKplCNN?=
 =?us-ascii?Q?thKj53GuijtgsogU2VxgS3fJmo3oxxZVPE2M35TlHXXk0cdq49adW0Q/8LKf?=
 =?us-ascii?Q?jCc0c4VGXV6JehzJN4jysS3zPh2+72NVGRTl+mODYx5ahCAyt5TP5sxhF/V1?=
 =?us-ascii?Q?4+3gbc9waYTJ7oLgxT/du+WtL/Nj0xKot0H6HRhUzadqrgjvkVFEW6N4r505?=
 =?us-ascii?Q?/kNH2Wj0nYy4WwVopvpTl3f0IVnYH26G8bHHXhSGovxNkeSiVoohZ+km9Zas?=
 =?us-ascii?Q?GJVrm+QMbhzP3dWxIOyfnn1QL/uwALJVTjzjQpahWhu2CCTQQrIvgf+PLCPn?=
 =?us-ascii?Q?9H/0ZUDYX1IhYUzyhdi2+3V2E2Qgqg6XW4o4Dv8YvDckRsPsnxLtzT+1Peji?=
 =?us-ascii?Q?Pj0mJWRSwlKFCgkHDt2NJgOkX9d20zAAXHLA1GkyzALG+a5cZ8+4fJ1uiJ3g?=
 =?us-ascii?Q?aAQ7SF78cn5GLcQkhTAdw0Jigmyt+W/5pm3UpjM1SS6o7F1oVVsqail08TyF?=
 =?us-ascii?Q?HB0m0NX6DH7I/u0N4zlNEibh7m0lpYcy/KCg1Y8DyJ65jEXNxVd2yV2uqnZ6?=
 =?us-ascii?Q?WyG5K2FxAjo8ebLuJHopKwgLViuPexnazmjgs0jOrom9voVyWbEMXaBCOgNP?=
 =?us-ascii?Q?PdTtUOupxsuQl8eOv9oxiw3+rD06tdQWvP02XlqSzU9CgX1mD4oj2H1Bru8z?=
 =?us-ascii?Q?DcpT2lAfFunpwwi1YDAeSYJAFvgOjJBqVCO+Ec6jBDkUoWey6IbPB10a8++R?=
 =?us-ascii?Q?u9Rif9/l+uh4MCs4lSvdF757wiLXRO1rt0qKVHvFAyzpYArI8o3sMzYgJ8Xq?=
 =?us-ascii?Q?DAjnz5mxPAjH2VT3HeLqj0O+ViT026ZxMMXNUIc/YaAV2MLCn+A1Y7ukhY0g?=
 =?us-ascii?Q?6j8sZs08dNA0VXUmgMSkxh2/VongF1EEgULZBipzVSphZWcCAWSdItoOPVYm?=
 =?us-ascii?Q?W0pn9GVb/iPtxTaaQFOfRGs8tdqC/jLT1dclNialMXRbuHmJ1yC+XqcUYLc3?=
 =?us-ascii?Q?nAUmFZYu40vQ7Vwe1+QZCtaErgqUkzAeWv3dehjU1bysXZOvtAqYJkju7B4Q?=
 =?us-ascii?Q?t+dkx3bSxNcfPGDkNeVLk9LQC+8FYhi5c1XauFLauqmMA8Nb5NyVzriDSmfI?=
 =?us-ascii?Q?mAnN3NylAK43jiVHm0VK4E5h/bhvr7kosoUh9E9hoQvG6qvX1ANSuapA2SY2?=
 =?us-ascii?Q?/qn0ZJvW4nEd6zYUTKqIe4DFa2kKFJOuFCEnhbj4WX25SpOG7dyGuPf/1XVB?=
 =?us-ascii?Q?Rkgjrtm22h4MGurk20fVYvsRrm10aaD0yOKbtAxOy0fN7kDE+nq8rUDPpGWa?=
 =?us-ascii?Q?6+uqL/boEfgm9tJkx/qiip4OC+0RY20FpnoZzxw0/rQLFclS0+J4ULOPhQOF?=
 =?us-ascii?Q?qJ/GCbUP2Vh9lCZv0iCMqQIJkjbjlh900huLkJoS7O3BoHDBLcLEZgLaf1kl?=
 =?us-ascii?Q?VSDn2zV3Kiyh4Ce8N1zhlr5NyhvFmBPPQ84/nYTWcCJ3IL7PcnLeDuBCYatG?=
 =?us-ascii?Q?OAiJNcd/B0ffH6MmEGYPNkKb56Rn25W84ksxxOmC9WUfwGVRqN6RNG338QLC?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mFqw9+RxjF6C1uwBiPPQ9WqDXIUUiR9LxopZxEyfacTWCrAHyXvLPuBXhz+gSKK6gIrGxmP+818Ilu3xTqN5CRIBiNxho0mKHotpF51d2Hla46pDRtyFLfbgu4vhukef86nO5/FWgvQbhCyIh6MJs7ygx1w4iml6ogmD6kPl2GHFrDZnCnxEcyVe+OkgHYyp/1BZvruSgQaY5YlpbHtSQPIErCNr5/ExPwZ5hh38FxU2UPqDv1dSIorI45Q4+fwDrP9Qbk8+hSO/mCNQvyFSt7RDITdKJ//xx164MtlYbkTsHwNL1r3sLxxJv/hJ+eJRdjl6nbmwpG0qcLgGiCIp1tLaNi7j1Z4DkTjKyPTxcQeMaivDMwgfFwVlMhNC/w4fhporfdnu8ECw8/3AYbj+tCuxWEIqQhrsnayG4m85HAI+cXGR4rD98gk/RREzswwN5dMEayqkjnkKkqGV0jMZWmXT57KuhQIDDIowcnVJ4nRaXzmX6LzEjYdAfUi2H0hfrIAuBlEOLNNxmk6MbctgcWKyjF1hhHLkT3j7glnmmEVp91V+mCuSLS+ltFIRQmTMCx3lnhMp3xmWIWvFS0L1uwVmEfTuCbckqtPeINe1qKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf08bc6-4cb3-4600-763e-08de08077ba2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:37.6401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fYbFkeqS6uzYnXRGmXWmFORbGOtHsnA/6rYugiOcFEIFbGSEmT1qA0s4RrNhVIpWb0MBolS06mKVRHk1ASMTqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510100082
X-Proofpoint-GUID: Yb_Di60uOFoNGTxxZrh1_Q3oRfIVcOws
X-Authority-Analysis: v=2.4 cv=Nb7rFmD4 c=1 sm=1 tr=0 ts=68e9150d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=iQ0eGL1bR3Y7-yOI9L4A:9
X-Proofpoint-ORIG-GUID: Yb_Di60uOFoNGTxxZrh1_Q3oRfIVcOws
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXzT3STm4D3VkA
 fFDTHgpPG7KfTWSfH+pQVWkSDXUiA1RUd5vFMWlRb00mGJ4v09MSlTDFAjzuLo3Om+5kFgMfy9/
 9yIs6k/kvbcC3yETLr9fc9t9xgvkDVysQS0zya4e58uKKCJZkQMSK+UP+j6l4SsyhKKUPJcG38c
 xwtQxYZYPqI8eFVNNr1wCGHVoetBKJ6DtDk+FLvV27DOeSUwnx9ReCBSmqFgFOEdhNs6hRuAvDD
 QMNQj9c40QCL00Tn4QnPdZJYJqTpBRPmgGUfkwQsi+LRKVvPsjZZfyIbHNF1yCgRBeeJbsYBO3w
 wC9dtFNw3ZHHGKPCvPjOp2AAB9IHAOqp1SYm+Gc3wE/GpSmVpOIyd+iZBqP3W2UDLd8YU3Rk9vw
 d4S3vaUpK3u2mD2hV39kBlXeVtYG+g==

From: Mike Christie <michael.christie@oracle.com>

This reports the atomic values in the Block Limits VPD page.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: handle not having atomic_supported attribute
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_spc.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index aad0096afa21c..ddf8104645d1e 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -521,7 +521,6 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 		have_tp = 1;
 
 	buf[0] = dev->transport->get_device_type(dev);
-	buf[3] = have_tp ? 0x3c : 0x10;
 
 	/* Set WSNZ to 1 */
 	buf[4] = 0x01;
@@ -562,11 +561,10 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	else
 		put_unaligned_be32(dev->dev_attrib.optimal_sectors, &buf[12]);
 
-	/*
-	 * Exit now if we don't support TP.
-	 */
+	put_unaligned_be16(12, &buf[2]);
+
 	if (!have_tp)
-		goto max_write_same;
+		goto try_atomic;
 
 	/*
 	 * Set MAXIMUM UNMAP LBA COUNT
@@ -595,9 +593,29 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * MAXIMUM WRITE SAME LENGTH
 	 */
-max_write_same:
 	put_unaligned_be64(dev->dev_attrib.max_write_same_len, &buf[36]);
 
+	put_unaligned_be16(40, &buf[2]);
+
+try_atomic:
+	/*
+	 * ATOMIC
+	 */
+	if (!dev->dev_attrib.atomic_max_len)
+		goto done;
+
+	if (dev->dev_attrib.atomic_max_len < io_max_blocks)
+		put_unaligned_be32(dev->dev_attrib.atomic_max_len, &buf[44]);
+	else
+		put_unaligned_be32(io_max_blocks, &buf[44]);
+
+	put_unaligned_be32(dev->dev_attrib.atomic_alignment, &buf[48]);
+	put_unaligned_be32(dev->dev_attrib.atomic_granularity, &buf[52]);
+	put_unaligned_be32(dev->dev_attrib.atomic_max_with_boundary, &buf[56]);
+	put_unaligned_be32(dev->dev_attrib.atomic_max_boundary, &buf[60]);
+
+	put_unaligned_be16(60, &buf[2]);
+done:
 	return 0;
 }
 
-- 
2.43.5

