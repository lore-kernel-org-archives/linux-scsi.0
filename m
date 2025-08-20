Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190B22E403;
	Wed, 20 Aug 2025 02:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755657080; cv=fail; b=V4DwhkuXcyHzZ2+iQw24M8k5N5WCyMCD/R7tvPhyNMRZUt/hfSy8IwnX9kFlc2AX4iYOG+dDb4roJWwOkVRCkDrq3X1VdOWf6GsE9kmL9F1PpgMFC+VwpAchkugwtj+2q3v2VRb3RYs3b02S6mjIXa2q+CGMTGx33Or+wuG9S5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755657080; c=relaxed/simple;
	bh=EeWGGSu0Q1D7TkxogTSqghSCVON3M2XnGyH0my/A82k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iDVO84NqMBZ1q8qdD+wJ26K6JxLCMNBthfcW/WBv4m4Ox3uCeXKo0VoLw1uH3bANp9XexoqkmL+1oA9s5RWU/DTNlIMnkNt2cRwFA8ZfySto8rbQZEUGXjkx5qX8kWdiBf9My7vHae2lMWQiA94uU1Rk/GY30O8kdywpi0a5dvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=coPKmzX3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wg0/aNKg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="coPKmzX3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wg0/aNKg"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBok9002956;
	Wed, 20 Aug 2025 02:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=C2Z8hYQet3yaWRJ7jo
	LP15cUDUv6JnccDfpBwswKXDo=; b=coPKmzX3KIkrJVj28LhQZvaZeMhBur06QU
	AsHn6h2OstEh1Kj8HUJB6m1jdrAlGjxUJIOZXAmHTDv/v1XHaSCX+4PXnTRKyxVi
	Npbi2utmzYsTYNWkoyHPmBuAIA1dbgO32+iNRvqkpJpG+wWtm8xjUrRrWgrTIbcH
	mh7eItUl+Irz42dWX1mt/SuaCHtSeaGr1/X9dub3Dw+p5p2UTo5SaIP+AhBndy3G
	XEbNrnrp0v6BTRisO9ZYO2ieZw7CbLXYgGcFGkPLilIpy936GA/IFijW8wnhKCOZ
	rJrL9l2l6MSVAYSLQbrYR4T5y1RsRl9NJ0Sf+hCKLE2E8T2C7N0Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr0a9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:31:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNpRNJ025400;
	Wed, 20 Aug 2025 02:31:13 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my40m5cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:31:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIFk76hyrm6pgy9ZrQOoIwHXWG1fpaKhjCNnUuDzMaj7AdZL1MBGI9b9w1KhNhgoQ7I81CIBJaVEmUNHT+adjMISnkhERhD5frLIREF3Ag80gnO1zYplNButJWYEfDltJxXTfExctaO7qRwhoyz8LmhpoNGpg43y0WQiuZyBapGh6OYWAlBVgFaWVKHCoQnG/BZXGQhYVrVzb65BVU41jxgtALwSroXnlXX+ETb6OEVNrbvwTSr9B3VCLyyzjXxmQsR8tYJ17b/qpuP9NWolW8VNg64qtvxcYnZXql73M3kJ5bibMXaRqe6JtgwE3OKOKbqXXWwjlEf53IqxJVL69w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2Z8hYQet3yaWRJ7joLP15cUDUv6JnccDfpBwswKXDo=;
 b=jSeYWOJgVomLbfbW0lI/49DI4p+ANi/1y3b8VXlTT7eRW1Dxcm06fjPtwCBTzbaY6gowGIRhSHCCEhGmvroKZcwsRgK9j9H69pyzxndC3UeRmw4reC8Pgx6cd9HFdkE0RxZjbkwg6thjGLZQfXPPWTHrZ7mdEH9XyK49xUBNpY9yX1aIWLy+bJ1eYzl9D1dvmhX9L/gfTvTi/mZgW60uRg+fOr0bmOBOCPVHmLymB+6OQCESBhfLdj6RLMTQD07j2RTADNA30h4HeeYBtKRLcoYYA3A1k+scMtRMpTle4F2F6OXxs6F+8toJnX/bC8Q0LUDFP881ngw+o16pztxpyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2Z8hYQet3yaWRJ7joLP15cUDUv6JnccDfpBwswKXDo=;
 b=Wg0/aNKgHXWiNA/4dHAk24h52OcNiCt4aVN34KD5H9s1QO0T7rZ+kDTUPo2mA750Ktj9UEuJ1Og3dJECRt97CZUljBXjzUp+EgerrOfVMP42tjCAOa2dl5rUWt8mOueWzhTutk709oaEeKpKtKyt9Lw0IUFC1V/BqiWnMbORNf4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4761.namprd10.prod.outlook.com (2603:10b6:806:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:31:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:31:11 +0000
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: myrs: Fix dma_alloc_coherent error check
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250725083112.43975-2-fourier.thomas@gmail.com> (Thomas
	Fourier's message of "Fri, 25 Jul 2025 10:31:06 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ms7uvi56.fsf@ca-mkp.ca.oracle.com>
References: <20250725083112.43975-2-fourier.thomas@gmail.com>
Date: Tue, 19 Aug 2025 22:31:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0335.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4761:EE_
X-MS-Office365-Filtering-Correlation-Id: d63594b8-6e27-4988-0f74-08dddf91a04f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KU2ceXkBWwqD0vraW5tnG06ahVLsZlBp/S60NjDzbXCjhLlg82tgoP9mhp5K?=
 =?us-ascii?Q?MXm2Eta4f+DemTYpe/R47F0qiGnseqT24+x5EbWyevgI9MD/N2fXqROO+S4p?=
 =?us-ascii?Q?L7DruPMF0JBoQxePcScZHM1hMro/6WSiwU1QlPLsk2m8hbOtUY6UpXLyLDY8?=
 =?us-ascii?Q?OYgdA0CG1C82SXB/tA9FowohZsdFxOgM66XnVsqYd5mPWcBEJerQhs+xBa6P?=
 =?us-ascii?Q?qF/7AGqK/kjOra5H42TYys1Bq6IamLVfStCQmkUAWKpgRAwwzqAFWO5/m+Os?=
 =?us-ascii?Q?DNhXJ9OBS+AqlSlxxz4ODkcohVd1LBKcqquzNZNuNkOOuDLcpwGLVBqXgDKM?=
 =?us-ascii?Q?92ivb6Jve1Hw+JH+phtInBDtYpZcuDLvQJNEouqR09PAxF1lAOj40tAyas7u?=
 =?us-ascii?Q?pzIbgWJlbvdQWP99zYZ+2FMS4n7PVzrjx/89f9gBCRVjbj2GsR6J8ymPDWlN?=
 =?us-ascii?Q?y064sVliijTaXUUFzFoSy1yW+57Hyr4agc863hBasR3xQhvLkQKhiPEFoL2g?=
 =?us-ascii?Q?giX+f7JqvAKdKBIbmHKOLYcvof4lRF/J4c9bNro2FgLmPuRyWR044hu7Lj4+?=
 =?us-ascii?Q?0mCySI+CNBz9P4/IELBWtyNmTpNtNh7WT89Ec3vQj/TSFOTcLZLwWQWncV98?=
 =?us-ascii?Q?iZcVO9uAhnNf5SLAW9n+6XLDTiZsdRgejgIs9D+RY1EaJrYBV43OkMC0vQoe?=
 =?us-ascii?Q?sEDL2OJTG8UGFkTBv8JLT6t4KfGuD88L7LZxDVj+W1uV3VfBpGnhKo1jkJzD?=
 =?us-ascii?Q?SRy9+h/IY3X2ojn69ZTQlVAK0KgZtpblZUXHyxtnplUTKFqsu/wGjwq2aZYy?=
 =?us-ascii?Q?Uj2NRBJ2w3xhcbRi6H3EwfkTbGU6y6FHbIU2hl1sDU4fLyA0EpBgHoUPslED?=
 =?us-ascii?Q?AP9q1pmYFW8JJafhgMJ20wxPSlEFCkhgT/X891QQp9O7MUMB20B0pZL3Kydg?=
 =?us-ascii?Q?M6fB/V2HV4iymLqUUK0FTAzIyYxYwsfFUBoVCxw/P4NitdW8tNWAYWhhI3Uz?=
 =?us-ascii?Q?XvVK7P9/GuNYA4c2m/Qw5QcqVwodtgwJcTlPtwttohArj6OnULNk1JFejR1T?=
 =?us-ascii?Q?RJHzTC3wfbawH9hrbJ8aTA8RwxbMhJGTIf0jlkhk4fWdIKm20mqpd7VD+z6C?=
 =?us-ascii?Q?Y/VgAIIR5S5W+m9qrNz2LY2Kr6qGEXwL36lfbETj1yzRzGwTZS4c9xwnRBAu?=
 =?us-ascii?Q?w3XXBK5pjk2VdkyTTOKb5j4Lcea8dM4XGJ6D3Z2dZeFoLcyW0310HJ7D6zZy?=
 =?us-ascii?Q?ySE4r0v39Y1oCyPigffZsOV/orKof9sE6UAXAfYaMU34Jp1MQQxSZQ9OB5Y9?=
 =?us-ascii?Q?Hgh0eBvu2g43+qUI5MGgt16iOQk1LgswYuEsrKCUnnC8I38jmevj1zVrSHOX?=
 =?us-ascii?Q?NCO+h2vQ+jiPGCVK5Kj+sSJB/2Up8sANe/KYrlGtcHRmuVnkPQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+VUXrjASxRLdUW5BrKJzxGI60x7n5fGp/yJzaMlrNYvMg1xVYACYHMQ8lZ1M?=
 =?us-ascii?Q?JfJa59i+voFp5vLU7hvtvqsAQNZ+6dw8DjqZ0NkQQQvQQsQRIux10xHJj/G0?=
 =?us-ascii?Q?5xM6VUIZFUqT8F6tW7aqz5wuJgVGmh9G7Uti3EqxBzlDPnhBJedos9yiY2xB?=
 =?us-ascii?Q?hPzVfAcSzovDMOGN3c2Dy12R4PDDdCEghjXNIMJBJXN77ZaVb1U0nISINn3O?=
 =?us-ascii?Q?54hXPisYEAdkxM4z/2ElkftmIMKYQKMCmpfgZo51r5KojjYUkR6V7ixXGMCC?=
 =?us-ascii?Q?328m8utS960cHft41sXdoiHnwE59dWCyjuk6R4E2keHSP1bLOCqLooV7BJ4f?=
 =?us-ascii?Q?NBBxikUKxcxiOU9Tw59fOVLgYr6OxPej90gLw3KPNLjF2a4TxhvOGlnj8KHg?=
 =?us-ascii?Q?8zh4qrTzizgTVZFcPmF8wmOobXbHuVVBKMksFkww1ShJLVnXB2rajPoTafAi?=
 =?us-ascii?Q?WQY0QZs/+rpAoLJWGHjIOMYDTacZvnwp9vOBacEFmpsJ9KP8pfR8ZZkC58/O?=
 =?us-ascii?Q?WU3RXx2Y3J2nogtZWebeOeFZGm0p08rWvXo5cRzCfVyYdylisEMuPvuO+Iwt?=
 =?us-ascii?Q?nl4hlg9gQgeOJ1mz98E0e+44dPDkclWbmQ7xZxANsBAmrJ+Xj20dpmhXd84i?=
 =?us-ascii?Q?VeomVkZJWvxwUCFkCTpbz0R2giaz2PkLU3W3pBYpxRLWlPvLJZBZUMpr7anP?=
 =?us-ascii?Q?PlPbVV2Vjd3dc9/3jTTPMD9kEorVeMDFHzL7zuv2/W4TrARZ080QODDS519/?=
 =?us-ascii?Q?Ybb2znaKXNWID12Z8Ngo5lUkghTHyuu/9ZIsMX3/euctfMhAbDaduF7pBJjC?=
 =?us-ascii?Q?fXFuhn8Fsfb/8zSI82OzwWrCrsH08AtBRlSOfeFqfAv0/L5iomrdO2lXbF22?=
 =?us-ascii?Q?92zzfvlyj3mpgAzwFNQHFoHZK96dQZ38+FEL4srgjnQ5BTatJUiYGf/COX9l?=
 =?us-ascii?Q?inFtL3gCyjPMv6MA1cuZQ4vYgImtiEHTABoSZKvpXj/y/1WLQSqkbowigm1d?=
 =?us-ascii?Q?zFw0dsZ5Sr+aNFn8fYZnjf6BHnNBpHxKNTb2bwS2Q10ihvREy8pRr5GAh5I3?=
 =?us-ascii?Q?DeTs0ZanXc+EYgueeTgmldS9XKTv0+K3r4cqHTp4gTOeuj3jA7VTqPf8Rnwf?=
 =?us-ascii?Q?GPC13j6tuFecv9bEDyx2hzvClzombru4s8e8Q843AVZYKMiFKaBxRZwoGA1q?=
 =?us-ascii?Q?X/a/7dowC7mrdf/2wIXIJSnc27reh9+31elwu68Y7m0uA920cmAV0fyma77O?=
 =?us-ascii?Q?GoyRSM2B1AE1EfQ6zLOPt6EQjndeKujHCFAOJGHbAFciyAL821Ucb9QKCAsS?=
 =?us-ascii?Q?fD+cxHMZB7f+u7sjK9+yhBqA+xGwBSVpfItQHggSrYHj4RnfeYiMH2uGcxJC?=
 =?us-ascii?Q?1icdN8GOIfs0FPeW8YNe5o0niQuDFaNr4PDCRwYDmsVeIBPUbjGsiQmxEW3/?=
 =?us-ascii?Q?lb0arEqVp+PaOYI+JEvi0EaoDfkIqGGTpn7vpjjXE1d47CIBXSAsfyooIqbE?=
 =?us-ascii?Q?zqHyjVXppWYs2SO7SJoDTsqWfKqJF+CHCc8rd678oz4mXzgfcLlcUcIZSxBe?=
 =?us-ascii?Q?EHZYbREmbvqRof0gyDDaAt25dOX+LdDJaY7UqDN1LqnNeLnDSUfe+nzjAAJF?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XFT/Vu2qE9PvgeWnVQVK7veRzTnSfH7TNAptpTisgp+2CxHKDPp+5YQ0oXdHuw4XOTf3+2g5Qpw6dhKmPBVElRtIp5w+eAovNx1dH0eLwFqhxJRLnlG3fhu0wqQ+lLwjQHhaOTwwAm5wI6T3Dgg18sD/HBVBFej3uUBO6cN5SAA1v+aXfhIhyFehV/qqHZ+x71HMezaC9CIx0nxUci7o6eqfiAFMAo8JPhfDy2XvIAP2QqPGlY75Jcme9W/lrSz9sBiQlCZb5czeVeVRpVU1pT7VE5udbb3s5/U9gYxp3SgV6orLnAolW0U+NzE1Y2otARaopD4zgT3D4QJVb8NSV7VIPMYZVLu92FnKiOb/JSfgH1uivtQsA+T9ZZq3P/FERsLfCZ0nsygj/ZYkluJYDB6HDo2tqDdDvk64/365c+DR8LBicKA83Et81/QTA4KvpN/ZT0TIyYekk94OtR+341EkZmGzZgw5/dx5Xtm8CgYvcSrXRnvAPZj1czF77hGYwUS1vmyrjECX8JrMmtoifxDHY1S+ZKRkzyZYSmlb5Zqc+BDzdcAflR1yyolIqEHsJfZtpo6c24dfKluFs+syU7oOo+XHXe6u04V9wStD3pQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d63594b8-6e27-4988-0f74-08dddf91a04f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:31:11.0573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3cCa1zOS/GR/xfmP/mKqqS6+A1TIt36igYGVdEvzJKBZLHdT3WuRQ/tbP8aKD93iBvFndPH0mTlY/mAgCn+Ou7TeZUkjUQe0CMljJMYucM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4761
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=672
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200019
X-Proofpoint-GUID: 83aXYqErm6z63jo2vBx_wqJ7f1NpFBcC
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a53372 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=cQVHEk9035qCPv6juNYA:9 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: 83aXYqErm6z63jo2vBx_wqJ7f1NpFBcC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX1bZ6Lg1YvDeY
 +o0zvJcCG1FBcIQmYqy0kasYP0jwESvPWmJeyxrurQfCGIR07xPHADGr/MOxf4egsfomM0b7WI+
 PtAvtRhle3JcsxJwvstAJI1WU23LaSImn0Cf3LWPH/nw0YOmjXnzeQdbgimST5jEmAjNsu1yqta
 zmOwkgzU84FSFFEwZgw/gl96ktFKp0iYL78Ayx1dI6I/WqJI8jiFTizysoA6UPpmDggduI6O5kA
 WSQ8vhOwPXOzjoKocrU9ufbRxqNt2m7eX+I115+vS2+p/oyT1lco09Y+SA2zaRvA2el8Ic4G96u
 GV0IwGrSbntFRgBrOXu2nwEPUgpAlFaNyPJwGHNn94LsULhOZQHD4S2D+Hz8AR43gm93TN/DOVj
 lIDz90HOeOBqAayfj9Y/+1/huhsn0QqnSeosjsveGSmPwbLkgqw=


Thomas,

> Check for NULL return value with dma_alloc_coherent, because
> DMA address is not always set by dma_alloc_coherent on failure.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
