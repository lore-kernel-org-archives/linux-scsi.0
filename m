Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE071F16B;
	Thu,  2 Jan 2025 22:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735857511; cv=fail; b=mUVfHfQ8mUnVgF6wDJurba5eN63RuUTvt7eAuVSMms/4QfnVIjfmbso8bYC3+DYQpLZfu/l1YB2I1dsacbvZzlZyKtyLYs8kLTkJEaCgmastnfwUDZ9s3ebK7g2OzHiI1Th4UzzrZQ0XhEko+dvv6Mj1VEznJinY4JtlYPq8gCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735857511; c=relaxed/simple;
	bh=65cBMjXA2QJYnGgNhPGFPtN+eU9beLD3/dtiHSyeU0Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DlHWevke/EKTtxcyl2g6YwNqzgaG4KGSdgR+KRyrmyqf0OJkdPyk0zN9DB9q+Sc/k9TimoJBLOI1KkvBUOMzsc9ihiWvAO6vW/u/UsCFBfq5WnnZ6TqSd4WTdAf0rQzMS6FMmL1ZShOUFJAOEsNnxx4eTuiC9XXI/HpsS2ce0IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y7oD3R1K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qfaeupbx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y7oD3R1K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qfaeupbx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502Kfqj4007921;
	Thu, 2 Jan 2025 22:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=L47p+3ozc0Fq/gllud
	fGxxeG3TK+oo/IprODH4XQSig=; b=Y7oD3R1KBUiyTtiMo2SmKSusU6F6K19JvX
	tKi/ZZo7Ey93a3kzx0yacP+xzAJMGwipv85Vith4hwMxqbdMkBOGL7e6qM1KZ3xM
	hWUHoRuXWGnf5FxS7FYxwOOUQla3qktDs0sdupjcg+9Kz0NhXBLMDBQK/WRv0LJ4
	o+ze/75i46lTVEZoms6plP4jJ8TNnNEbLxc8xvrpvv0EiOHBQdheC5YWKH5+lsfj
	VnPOEeSVkZ9ETK0tm7zgTySUO7pZ7cxPPwPKCw8CsICe9/tupjHdc1Ih5qM/s8u4
	ndCBxTHqRcKd/wEwBxzHaWU16Ik/RvnRZyesb61lYZYPd7O13sjw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t8xs7a0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:38:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502L4Z7L027660;
	Thu, 2 Jan 2025 22:38:22 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43vry25me7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:38:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVzhrskhlL3bZZcq/QYDBdJ0doti+iX+/kqmpqsHVuYk0/K5LZ3PGvhQZCRYYfHU4u1hlVtNslv02G4fUYR5GcDGUYwPcbB7tFiH+lQliA0ZxYX16ZdUufdJmBAJ6KL0B+J2g+2aD6PT7q45wI2iNCFgEmJplwZQcAXn9wwPhfQrlUgCJHxAxEoiadsdqtcSfCHqLfDB64x1O+E8sg8YR5y8JlvPLhOmNhhYz+8YSLBRhMUqOt6fzlvcDqvzQQAR7C1QrfRTpSYZFmO2+0CXMDQP3zLwjLytM7n1sjv/9E1efOnXC6YO1jHTJEK8shS67eA2UjsRoNTRm2I0suUWrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L47p+3ozc0Fq/glludfGxxeG3TK+oo/IprODH4XQSig=;
 b=E8WcrnWRjpbV1znbiCVp1+wVgC9TIP7Hl3hnPr+dJ+w21ucolZnDSE4UUTRvQSOWFYUrSF5w+qwDMz0mF9VWdH7t4FWHrVjGmyO4sNBi5GjxBgsdwbUJ6pSpT3/ZeuSoVV6wpqFXSLBqG4AJqK7i9xcZggR0CnYf2AXfxmnjcVPpq98Z7CSL0dx2WzP6Ybdw0n/jqSTz2yk9jUK+uNC4wHkAFT9wraXfvi1CNIiKCs94BgO66w8pLAQuAoL5F3l9ZifYNd/1BMR+0yooh57NuwSBuQ9JaTN80fLzICUupbXU352H3OcYrtXswqCSmXv1dgoTWPGm3OMIYJnvvgwHFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L47p+3ozc0Fq/glludfGxxeG3TK+oo/IprODH4XQSig=;
 b=qfaeupbxf+QcZU3ZSTTUE4CUJoG7af45bOYyEn1+LlcgI7vEeEGMvwBdL8y82sn+k1yODqmQDdTsmQN+nSuAriWhV18/ubs1Np64idnfYhHEAr/kJr7wD1/rEQVQ/VzfvJEP+JSuD0VYh3wyU7/QMeNdS7mgRQfwelqcox3+ApY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6514.namprd10.prod.outlook.com (2603:10b6:930:5e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Thu, 2 Jan
 2025 22:38:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 22:38:12 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: Documentation: corrections for struct updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241221212539.1314560-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Sat, 21 Dec 2024 13:25:39 -0800")
Organization: Oracle Corporation
Message-ID: <yq1pll4depf.fsf@ca-mkp.ca.oracle.com>
References: <20241221212539.1314560-1-rdunlap@infradead.org>
Date: Thu, 02 Jan 2025 17:38:09 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0072.namprd02.prod.outlook.com
 (2603:10b6:a03:54::49) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: b3aa6a14-0fb2-41f2-8418-08dd2b7e23b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?irdIaUEUekG2DqpPhzBQy7+3D1fAHv7RJWmoJAWKLTQ7Qxv3ygvmmVc0Yoth?=
 =?us-ascii?Q?erQwVDYPMrXRBouyjSwcft7x0+/k9ggo4UwPaQMrOqD/5oGP5yURHqznSdaj?=
 =?us-ascii?Q?f2ANF0cwHuSZou4D1QRrk+2VgEVKnesvhtjlpNAiqcadU7gLK6tIBcdUS2+6?=
 =?us-ascii?Q?CYxk3uiskHht5veN8YKtUsDIINmtCUbMCX+Gr40C4i26Yb1tyS3EfguEAcC0?=
 =?us-ascii?Q?0VrghezRDIbhRcZYOWGo1pR1Ve0WrsSUr+CITW84qsuKzgpMFVyEOTXlWhj/?=
 =?us-ascii?Q?gcMpBrR8AtVCi36q4LZRa8vkAuEAo6kieDZ2dyN32uUo1Wb8wXIZ8+bBZg9/?=
 =?us-ascii?Q?tKvx8Hli5g7pMQ/AR3pohlw14uj5ztTgll31Ea5wVbt1h2kEarrS4pOIQl4R?=
 =?us-ascii?Q?HAm9TIc9jUnNH2+I3Hvo5+QFrQ+9EHnjDJsOf/6su26bcZBtMCP5aNRkOGCh?=
 =?us-ascii?Q?ZiUf3lv0lUQHxNP7u83wy0vn1+sDXcqk07uRHpazLflRDV1IKfzrFjMVcKE5?=
 =?us-ascii?Q?/fj+gZ9/4GjzQ4grIpREMnb3DJjetcteYk0QBl/YpJ5eNUcLYaVQ1LGpr/Xo?=
 =?us-ascii?Q?V5vime7JcdpG0AoBcMVVg9z+lGBBWBz2UfqLIcqUwZiBH0akLPpVkuUX8QJ8?=
 =?us-ascii?Q?wiQOAs+Z/YCHwPV9oBeQSOkTY9H7w7Gb1AyZ28wpyfHbrFL8BM/dfJP48VcN?=
 =?us-ascii?Q?n6YRKnOHoEqYMt+75E7ap5oU4rMpw+OoiR2UBhofSZVaiRnFNspARtcU34zu?=
 =?us-ascii?Q?teimYgPJNR5k7YfIVsfxTV9sInWb9Yzck8LyYwRYoUuSuESAs0NLwMG/7hsu?=
 =?us-ascii?Q?pOJlIEkFiYFhQr7pWJAk18Xs70fgE8gJN+FYfREZ6khwbN4bJbhGmBC+k/9T?=
 =?us-ascii?Q?90Nek/4h/MGGpK1RuxlZmN+VDq1rLg4FNP8MZxgTEwDWdBpuHLRxcpp+tU+L?=
 =?us-ascii?Q?zo65yX0jO0O++g/rc5Hhz6MgYbWgO6p+TEACCzPRcPec4pWWLOA+LBF9AKec?=
 =?us-ascii?Q?B5xtCWCxy/Ew1UJP7t8h2ezmRhLxDlg+Bp30ZD7nCQzxmj8b/bHUHu97vtWq?=
 =?us-ascii?Q?1UyBisOwofCfH1/hrUbjBkJtIGqnPd6eC0skHu3ZnGou9J1iTyAtVlBDjS+N?=
 =?us-ascii?Q?CL5jDMn7djin3K1djO5daHt9LvP70IoagWaFWl+PeZhx/LFmdJXybkKFoLSc?=
 =?us-ascii?Q?ZN8FL+jpe1REYX6TMb78GHQKoqIQe9Qg8ftDiR9bQJaMB8H9hfsy8eIJkggZ?=
 =?us-ascii?Q?zAb1QJDD7+qzf0lRr9XS5qUGtmSpNcQSSXyU5jJQL91QulesIa+0ajBtwbkd?=
 =?us-ascii?Q?hr2IHvXGxUIxBN7BU5T0Io5+XG+PuS0GhdEkXN3ItZaQUQKRhi0zQt3iie/Q?=
 =?us-ascii?Q?bV8R8orqKG2sixjw9viO1pA6QY+O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5pigeYqMwGQSmT5l6n/aPH66ISEsupKtwYZ6xn4MOgab4TpDyngpf8UIkHxm?=
 =?us-ascii?Q?Huwnu8lAI4SsRWBfePnAC5zTyuzBBxXZvthsyF5OypV0qhwuGUuEhdXv1Mc+?=
 =?us-ascii?Q?zwK39Ewpf2jAsf6YXWhYwVUcd3QJcROU1DnpGOlhb+FLrMpvguVttl9ZsEzq?=
 =?us-ascii?Q?oPfQslm2pjeuQySGBYHwII0pUfZrvSup5G4DCyv2pSQwrekduLlU+YJu2Hvi?=
 =?us-ascii?Q?9/kkdpOtacH6Tk1d5kK3Lx58kA5ndU8Oll97oXHD5ASv6fKQ5L2+AQifpLi0?=
 =?us-ascii?Q?o9pZAswrXBj0GEAO3ZWO4WTACNY+wnmWBaNOYgpZXEYiVpntpaGuUcYZ1pe2?=
 =?us-ascii?Q?LKi9FCA1ufLekOG9DtG1NklYtKKYHvM+G6vgHLxyAqj1EVFUyhAy+hMZGUtC?=
 =?us-ascii?Q?FfyUUvHYc0wxlhuOGMWnxi1ocKdCOnrpAxbzK+H10abYK/aWzT0AVxjm1//M?=
 =?us-ascii?Q?docOyY5OeIJ/r+fllCi1AiCRtY6GRjkrhNeFsRIIRoO14VijFFL3fdTFX8GS?=
 =?us-ascii?Q?8+tmbM3IxfNhaj3/vHzs3ikbYqkO5kIJmEKtTVSL8Pg2VfF9hmNqJOzmJ2FP?=
 =?us-ascii?Q?cc+zFowcU6ZyUIX/biGSd/4DWwgAPP5smlzupepzo9z5Cep31nNgGxE7HO5g?=
 =?us-ascii?Q?QUEuqY/uAKeNky7pyF0x5Esw6KMG/mtxtcvT1mvOUtAws9MwCoY5FbfImdgK?=
 =?us-ascii?Q?o0DeS9fS/ZWuEMupdA4cW8wUOTro8TctFA0eGQ9hDmVUzQ2al5Wxe1f6+r/O?=
 =?us-ascii?Q?aI6mcXsMbUCf7h0HgneVYxQqCWaEdEJcmOpv5MsQ5cjQ2aMnBFPAWrlH453T?=
 =?us-ascii?Q?ua7dGIH06wkIOM3Mv4RTtYk1xyuesl+ZhaeOq7NVRrQSCohv8TBi/fy6fy65?=
 =?us-ascii?Q?ZNrgl9Cy6nBW0i/bvIoPMNXPZ9MJA5qYEsigsxt1Q9FOwjekFbiEuosD0vBS?=
 =?us-ascii?Q?AasqZ7k2etTJr51IG0uc7C9N4R9fMvtxqGmuqvFd1b5ueVOD2/PxHv6LnPUp?=
 =?us-ascii?Q?AhzBr3BuCn8RRmNEmzaicDocSfyH09nOWHzc+8IWbzeV6a+IrvirR3wx/MI8?=
 =?us-ascii?Q?SsmTJqdznzdoAGVpUuAI7/6qSWKFMVWlghxr8g5o/wHH73ahnRFabVHg4L45?=
 =?us-ascii?Q?R4pv1XRk7GOUwIR0tGwCW+BzgRN7zNhCZeqJs6V2E1Gy3O3kIyeA8n95JD52?=
 =?us-ascii?Q?d+QAtf0FrQRlDtHXJL0KhGN2rBEzSk04eWVbgU2PDI9B3bnTlPk6DjFPX3py?=
 =?us-ascii?Q?meDuadX7p8wGSe0fOr3PgeLnw4jpe68LEVyp3JeO5BLGz6aemCNn3e83H6yj?=
 =?us-ascii?Q?FIm8Nz++6FWojRubmvxVZGGFw9nBgp43WizjUdJ5hYC1q3VEyarKVA1Uxj/G?=
 =?us-ascii?Q?9bdOfc/D4ZYjSvY2MgubXFfH63VHsAyRuJ+yfYejEM2DaE3upBPXbEQOVKkI?=
 =?us-ascii?Q?t+wb3EQeravNAujBecCYSr9PVlhL4kaqwiTNjuu5SeYlsyZ315i4A2mqtILj?=
 =?us-ascii?Q?95mqqvxwu2IOk53B+Jr/FB8qiEMLj9J82xw+I/ybcEhb4dZFUHGC2zv5lkaA?=
 =?us-ascii?Q?OsbWZ+S6+HMTj0itXKAfzbegWU/fwCRiLt0Sk16qtIntppB1ojB4/AhnAr2u?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TNu20CDTQsokZO+CSCGHUqnxzd6OLFfgvkiCi+m6twUFQTQzsC6qiiVF0TJ3AWH8XChTPuSVrzjx0n1/5fxSx6ZFhu+fNmCSoIPMdnnvzcGjV04GSZIVhYtAL5xgrPPIrBDwoLCfQ/Fpi/jGu2/i6TisBdMMZBysfDztET/m6bTIpXdMiy0OysD102DTafGlJxE+R95adPNHvw8ZAqDofXVlBx5wRooXu2pS2zoY3zfuO/wCfaeMnw6ouz4mQWJhghHxi/PXq5Kk8fozuLTb997LBYl4cbm3LhfHLKKe09FNGmWElHzqCsJ0Bt3yxijnLBC0qprEEHTijAVeYLGHoW0Gq9Ul4mdaduugHkZUW7WvwxRGCqUaoBDg9QyaDgOMH7eWoDuyKfx2fsoegld8z+w1GM+yJQ7vUB6Ah22qLpfCxjXccNOJl2LCBTfaw+zYXGw5rUme946UTHWKqpvVGYBAVTHkaGr6oOevpg8ACbcjvHb5/u0GfZ9Bv17FOj9M6CstmlCyqqckLiVGV58kNbpEK+Vaf1Mc2a+STFApGK+7YhRRmbh3NFtzKZHBsKq2klEwJHDWiNXPNmQxnlXyHitKv5wdiOa6BbkAvVRJVzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3aa6a14-0fb2-41f2-8418-08dd2b7e23b7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 22:38:12.3002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zIIXt5/x183dqkmDgMMjJhcJzAiLdnM3H0CyPrEZobGA+HSG7bp3PjG1AvAzqq1Ms2mh3rJMjqtpt5LHutQR5lKJ9VhVBRICC1e2w/tqHcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6514
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=860 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020198
X-Proofpoint-GUID: 7nS0U5ffpzunU9y4ioo4grP4Ome6jsDy
X-Proofpoint-ORIG-GUID: 7nS0U5ffpzunU9y4ioo4grP4Ome6jsDy


Randy,

> Update scsi_mid_low_api.rst for changes to struct scsi_host and
> struct scsi_cmnd.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
