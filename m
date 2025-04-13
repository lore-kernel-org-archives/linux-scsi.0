Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B033D6A;
	Sun, 13 Apr 2025 04:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744517112; cv=fail; b=SyRueWiugxcbWkm80mI42GjPUyCvOtc4x9XcVO130H5iGY/Yf+c78eFanHYRpYF2JBDlmRbDRisdVL/rWxVv7AoZZmOKBWTX99n9DQxGijtLdhYPcZTk/eTVRJS+kgB9YiCP1Nr1YjfeTdaGatfbfuOPb1ZdIBEGJGgKPOwxvBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744517112; c=relaxed/simple;
	bh=9nyYW31kUOCnW8G76VymNCKKLJXvp2sdPvDtxCB808M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SytjNm4Qwdqb4di3jnlqeQAxH8acN14DPJ+J76tDWYo6thlaY1YoN25NWwHh/yshCGBwKQREKQoGcg3SmhWiTcndNdYwO03ZuSoFS4USfJOqT215Hh9enXPmVzHTMgnTmYglT7CxkXpYTjfyJsKq5mpf9Ir5ffU8OjRXMU2S5iQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TUl1fuhh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w8bv8nQi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TUl1fuhh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w8bv8nQi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53D41GDE023002;
	Sun, 13 Apr 2025 04:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IXrBW+j3KMd2rEHbx4JpJOyfU27YPpGfL4ef8mv6/T0=; b=
	TUl1fuhhLVagvCWaJGpHHYRlUjo5DjODY5jOwajlgo1v4/up9g5js0u0BOEqnepd
	QI83ddHyztE7mIERAQ4DkLOY43gIhGWnLeH9B70vtwkOgcs0YXtvCcRhVI/GqqgL
	8iC6YDS/6If9HdLFQMgtXejDEZj9CFP8qiM9EuQyajzBdomVJWCDeloKp5rpz/22
	E1AADVfQUerPsdeISqFVzO0ixeb5A/gXD0IlsXi4FqzOqdlyj12NLZcDiSy95mnx
	gsr+vcll/kaqOhdWzilUg4u2Tdz51tai/cV4lcbRGNdY3jXltZb/W8LuGGzNZz+a
	dbMmW75NRKqNGlP3g2EJgA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4605g4g0d0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Apr 2025 04:05:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53D3NOek004934;
	Sun, 13 Apr 2025 04:05:08 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazlp17012051.outbound.protection.outlook.com [40.93.20.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45yem6h9g5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Apr 2025 04:05:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7AJJsDTqz1nEmXolRXIyE7WgT6zOU4lZAzQSZFhzj1I5l68IFiOEe+9kXe2A9CXCVAwiEVxW0K2VX/+9XRKTdskKvqO11NCe5xaUbyuOIn/uRVabLuDUc1D4AuECKDQxGATF9/dyWtbDxysB28meieglW1tefKO2MX0TFfFV6DCjGqkyvxgmkxpNuSH/IMyzfJ9oS6ai2jy29uDLHw5PCIxb6Ux6dCk/oHIknjnX8FAz7can933nYNf06VRgsI70pMv960Z+0QrPZuEiSOESR4KyVA9L7y0XA9nfTBStRnNWzURjhpjPfRE1yJOj661Cu7ijzrL3Xg1TRNg0m9e+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXrBW+j3KMd2rEHbx4JpJOyfU27YPpGfL4ef8mv6/T0=;
 b=riDQtjcvqyJqhNOnoZtL9RA70Asy0F0UymAc/3x4RXkmqkNTeiZZfW85Up4IqTFdBkvsPDdztfxMQenaHGAjvT9bafOZZyeMpbvaboeawy4R605NFWLTTO8ddcwOA6gx9yaTqMvTZpypoYdM9s1lzztMxp70FdSdiBbJhdTUcJSSHlgLnS3IpA39I/MTFaqbbgE1WIyDvQLBrrzs8p1BQg5aBrlLv61NvG3Is+FAafTmdOd0DeVEwJJf5w9P1EORk6IJi+yLP68p8++B7Ubqbhwur3io/9mbu9aR++OTUn5L/SgK21u7RDkRiBBNSbAP8f4RuYO0O3+HJtnGJPEgqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXrBW+j3KMd2rEHbx4JpJOyfU27YPpGfL4ef8mv6/T0=;
 b=w8bv8nQigTZj67hlxfBw+64b/A5gP0rVhU7Ofsf/Apzd2msd/MOvDQf18PA/PgMQEF6BMiAeh6hdWKjlmoShYXCcAJD39SOl7JFUl1cZto/z/3vr9Y5TyZI6205xStJ2MN1yEiVtWw8MpPsEMLMpbkRQPauWwOWgzk9w8G5RtGI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4120.namprd10.prod.outlook.com (2603:10b6:610:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Sun, 13 Apr
 2025 04:05:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8632.030; Sun, 13 Apr 2025
 04:05:05 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/2] target: Move IO path stats to per cpu
Date: Sat, 12 Apr 2025 22:59:50 -0500
Message-ID: <20250413040500.20954-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250413040500.20954-1-michael.christie@oracle.com>
References: <20250413040500.20954-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:5:337::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4120:EE_
X-MS-Office365-Filtering-Correlation-Id: 559b3eaa-5417-4fb0-d7ac-08dd7a405f21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ohejDK+Ja5rL01ZFErmODK35FVNLD//VR4dK7sL4Qu9nhZJ3o53//lO3nuCb?=
 =?us-ascii?Q?/g9w92fTLiRgkLjXLUZpV9cnpWAl3NgOHtaHdvEwTJuqAD3heb62PRsF1lrY?=
 =?us-ascii?Q?G0f2Xp3NExtRsV22EdGuvWhF8g/leyuGSGA7KoHfVYn9I5CZhLs6Cbduj55E?=
 =?us-ascii?Q?f/AitSGEmQha+qHc4iMYI1xxT4i5rGB/rDAr3dTi85KBPCw8gVtqVfwQZWB6?=
 =?us-ascii?Q?aIuu7fhF9t9js5uzcRsz7Bw8KJ2LT/URwFd9QBLjFNjxKbKuCUkeUNrx582Q?=
 =?us-ascii?Q?RKQ6tytWh2kvWvIGwcDwvW+OexLLRmSacb6/LeWdifTwGbd6R9QL8vUPofkk?=
 =?us-ascii?Q?ZJqoqI1/iGzAs8meV5dQiV2cJHoGoYXFNZTK5AgvCsL50O5lVkWedZ3nswFi?=
 =?us-ascii?Q?nOtWdHMGdfrunGFH/97n9QSMQKNKp2GAornzvrEIn8GmL0G8hS2S59ZbOxvh?=
 =?us-ascii?Q?OOxGKR3jQNBFVhtyKbjje1BzV1WBqdc6VyCSJBddEBdMT1W/rbdyXc7oYWKB?=
 =?us-ascii?Q?Mm4PWaaSlxTJRUMQAhZKBljH4HTVcRnBrfjJY6jpm3GrPtMlxgZWomm4EX3N?=
 =?us-ascii?Q?fDY+fa27Wq++RwY7ewURJznoKivWz4aACIX85I02vwq/p0BaMX8/9wplyjI6?=
 =?us-ascii?Q?rY6yb/1FJ8bHOaft9cbyB7GXwrP3mTik4L3koj48nuGgN+9xwA0DZZsN3u5C?=
 =?us-ascii?Q?EYXuUOPETC1kbhHauj0JgKHb+RKt+F5Evr9aJqzl7MqHL2BtyPmsH4Qe4YCD?=
 =?us-ascii?Q?x04x7UR9OnOA59r0SXL8NxQ/EqKB9hn8X4x7V9VcWTiI9X+4FzkX18Ti3Ium?=
 =?us-ascii?Q?CCxrktgNvUBRcE/NoLkOd30FQYrz98D5Q4SGALO3xWSTRNev6Adkmpzpi6ko?=
 =?us-ascii?Q?vydHTZTs2zNR8J5GbASnIVWDF6ftgVsHlDllHa+rusbj0X+JeLgFC6xFg0B9?=
 =?us-ascii?Q?6wQQUBh71qMWUjWmCy/J21vUSwTyybJgayJWgBiUBqCpIcsEtNEx3qAj9+pw?=
 =?us-ascii?Q?TKv/jJkkybgTvcVyaejIwauP5jTjLCA09ywujqWss9YtSUYSAbZsQKotvoTm?=
 =?us-ascii?Q?PUzYhXdFLfihnqJfL2BPy2fc90RGE67vnFkHJ3c/5kj8ixe38ilkfbI+UD5H?=
 =?us-ascii?Q?TfQjE7yyOFjku5xCXSGUbwFGWX7dVhrWDnVnWVS3gutwQ4zvxkgHu3Gsc+9N?=
 =?us-ascii?Q?oCLAZ6FWYv1YGZ9t6VVLfbDfkLNgozhHo+P1l8BcLj9a5jK75b9IQufKNGtN?=
 =?us-ascii?Q?QwBriOjViAchUI/zMHAET57p4CiqQF22O+NirNbQ06ytzWtN3Y6Iv6UteTwS?=
 =?us-ascii?Q?fIRKmHvPG0B5+Rkfo1xPzbgD2UXZV3Jd122cW9UtP7Xmc6D/BjHlajtiW2hp?=
 =?us-ascii?Q?DufiuICJiKj2emxMQEnNU4sIo+nBrxodsXZLXF5wYbi8MSY8Xg5XNmuHy7Am?=
 =?us-ascii?Q?AWRLVXzc+Nw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pxggC3m6fBdbZLbTp8KGzFGCpdudA65beJz6t8owKPDZEMTP/+DzZCwhFmpD?=
 =?us-ascii?Q?U0xRArRHPxtCaNCAfP46TsY4Z4+q0gwsIvnRwU2FL5cGNoLuRaleDHKbJ2S3?=
 =?us-ascii?Q?vamYeLM2X41QKB2Aay2wjgFk05z0DPAPOb3iUN5VlBRAql7O4SXQSl/dYGCI?=
 =?us-ascii?Q?Ge4OCSubsVK1wKQWGN+Wu2FIZt+pImW3YqIntIO0A+7q4KVLrJTuBZ6DT1xY?=
 =?us-ascii?Q?UhlMcKPwPO7VXFkKOmUDN+FHPwi2CDDJSsFRQ5MP6Pb9/RFOQgHUuyzsUofQ?=
 =?us-ascii?Q?1GG508+h8gqcQ6vGPYXyUsWR1i0hbNEpLL+KycW8zssWdyybFeZkVxqmmXfQ?=
 =?us-ascii?Q?vwpuIV9u82zn5Ro43T2zKa3YVkrynVUxOuvXB32fwkI5NN9ikEPzHoYuJAmG?=
 =?us-ascii?Q?F9PDDLqODbf4igKeHCCZz5+64Y7K37xZozFm2jJOy+I2WV5zxPXWNyfQI4uF?=
 =?us-ascii?Q?FFEyNS/Vu59bSodmd+mqRbC4Bq7nPga3A64CepSK5KmL5kIkqiit9WSoMlg5?=
 =?us-ascii?Q?8ciF2mkla0cZOw4rFmsnvTbQw9OS3a9Ij/s1EUfZ5A3QYQp2YzKq9fNeHrU5?=
 =?us-ascii?Q?cTscsJRCRysVyV/kX9i5C6Gd2KfI1eelWUH81tyi8rdIC+Fzle3ac6jKltDo?=
 =?us-ascii?Q?3ELD0N4VY7c3nyaZIly3HFZM6w30rRxNXXPiRb6+ycMGgMfGUy5ayE34NNxR?=
 =?us-ascii?Q?7774PH6ykbBKAmTUdVdKAfs4EpZp66JlUPK7l2tG3sTixSdQvTAr6tPCV7/v?=
 =?us-ascii?Q?6ZtU0CaI0zUK0OhfcILRGSCBZu2JjX4IRNwkd/Z5H+0qNmA5yCHkGnrB/CVA?=
 =?us-ascii?Q?wWiautmhijSVRe4GQmJTLgjHrDr+bR88BoY7hevbtYJdhl7J2zzMJTTZfCmj?=
 =?us-ascii?Q?2zZeLQYLT/npOSJ0MGWxm6dny7b/oXafthgVGjeoDjKKOk3lGX5D4Z2MBS64?=
 =?us-ascii?Q?ASbI8mH4BUnutsoLyoJELE2K9GPgToBgxoIHDwu/LMT629PndPC8MR2JOxWr?=
 =?us-ascii?Q?UQ2C2QwviQ3Sx7gGdTzawCgEH3wQZ+NG21O+mnIYc4U6Q8Y6/3ow30B8hVCv?=
 =?us-ascii?Q?Z9eABqjoJH/Nfn8vH8zJaK3S63eaWS+8D6k/sizyDm4zOLiJiKlxpuakPOav?=
 =?us-ascii?Q?TDxd3L0Ihy9JvONn9SgrfnTZFRjFGsps9QLBSwB3XikAnFUjm3OEjIg9XqAX?=
 =?us-ascii?Q?qhfG16rofV7pS9yNfTcG1nDF9YB9lCHlIwrME0XXWuVh42p5scIjlhVbHpom?=
 =?us-ascii?Q?moTLNXTFmeDTHFGUQdW30DVGCJ/2z8+4Vfpqtvsc0uzlQGpbaMpiSpyWXBcu?=
 =?us-ascii?Q?RzbgxYrzWIDKiWsPLykyffMXAMOr2c6nlz9RbayGBHKhkAJKGmpec5PYdiQi?=
 =?us-ascii?Q?AAocANisPSoZy/ivMxTYsr8j+3tE8a6CUSYwfwXVePpaKqkMpCjiQE1n4zaq?=
 =?us-ascii?Q?ZmR78VCld/4U0sS1EkIXLvw1Ahe1q06gu5y725yjzcCOkWN3APbUsDoqI3f/?=
 =?us-ascii?Q?odSzGXFSIp6nYEnczvw9j6R08t3zz48artw5LDjXtp6zVJPf2pUxF3mL/w5Q?=
 =?us-ascii?Q?dqSdfpWfm3cc+QH1b2SRza+/V+2PMd12qIkSTwwVp7OuzTfCQpI7JGUUxep9?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EQmAFDiX5D3lo/famgxakIbv21XpZ5S8Y6yv0thplu1gDj0iMr4x4E2iKt7sCKSdAXQLL7pMIbdjAV+/CYMwZ83wm5RrGlIdHAfLzw6s0WqnEfq23k5tBU3mPysX8PamYsOmaZvlON3GiahnBM1T80cCJb1/nspSNTjSnBq1IhyazgvNd9WB4rUDjreWNBJ5qXuxLzGu+71zwtQx5pBkTEjyxBuLPMdKa9IDgLrePn3ElO0EoOi9EbI4lB35MS9lQ9y/MKX6WwxqM/VtSZvVCORLZEvA6J7secm9INYmeXKAs6aOw8Q03CY+BYSrcSMR+Ep8s2MSWXg80ONtrh5QFJgjikotBrbqpMUyvIEpWGvEC1GIPBx7rjLaNxvnUUD7SYL2P1wCFJ3jJL8eXjXc2XeYenjjuGOvg97eN/TkAAJwvqT2RuhMgZcO7jEu79ww46Gk68bp0GIey3ZCtVHpGpIxo1+pKul5UGow+Bu5ic8chCjDpEKbpWtOM4Ytekr9wsOeCpguAdoGEq1r05FQIHjGJlFaDllOQw0DIeIg1f/7JuHzGS++JdzMXLxo+awj7sDqzHY+ZL5PATXtcmpkZQEAsouKlB8rfco+vd8F9O0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559b3eaa-5417-4fb0-d7ac-08dd7a405f21
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 04:05:05.0669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNQg3wZlJZh8OIXvRZJYED3YSQVRiljd3lk+sTxBRMJ6HTfIcg/FpwyMGGwx+SA4LqoXs7lp2B5m+J8FpY4B+PBBXDy814gUcQfPRtthSpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-13_02,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504130028
X-Proofpoint-GUID: YXItNpHCxwzPEM1pdvbbNNbF2EOfg3TA
X-Proofpoint-ORIG-GUID: YXItNpHCxwzPEM1pdvbbNNbF2EOfg3TA

The atomic use in the main IO path is causing perf issues when using
higher performance backend devices and multiple queues. This moves the
stats to per cpu. Combined with the next patch that moves the
non_ordered/delayed_cmd_count to per cpu, IOPS by up to 33% for 8K
IOS when using 4 or more queues.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c | 69 +++++++++++++++++++++--------
 drivers/target/target_core_stat.c   | 69 ++++++++++++++++++++++++-----
 include/target/target_core_base.h   | 20 ++++++---
 3 files changed, 121 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index cc2da086f96e..39aad464c0bf 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -55,14 +55,14 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
 	if (deve) {
-		atomic_long_inc(&deve->total_cmds);
+		this_cpu_inc(deve->stats->total_cmds);
 
 		if (se_cmd->data_direction == DMA_TO_DEVICE)
-			atomic_long_add(se_cmd->data_length,
-					&deve->write_bytes);
+			this_cpu_add(deve->stats->write_bytes,
+				     se_cmd->data_length);
 		else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-			atomic_long_add(se_cmd->data_length,
-					&deve->read_bytes);
+			this_cpu_add(deve->stats->read_bytes,
+				     se_cmd->data_length);
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    deve->lun_access_ro) {
@@ -126,14 +126,14 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 	 * target_core_fabric_configfs.c:target_fabric_port_release
 	 */
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
-	atomic_long_inc(&se_cmd->se_dev->num_cmds);
+	this_cpu_inc(se_cmd->se_dev->stats->total_cmds);
 
 	if (se_cmd->data_direction == DMA_TO_DEVICE)
-		atomic_long_add(se_cmd->data_length,
-				&se_cmd->se_dev->write_bytes);
+		this_cpu_add(se_cmd->se_dev->stats->write_bytes,
+			     se_cmd->data_length);
 	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-		atomic_long_add(se_cmd->data_length,
-				&se_cmd->se_dev->read_bytes);
+		this_cpu_add(se_cmd->se_dev->stats->read_bytes,
+			     se_cmd->data_length);
 
 	return ret;
 }
@@ -322,6 +322,7 @@ int core_enable_device_list_for_node(
 	struct se_portal_group *tpg)
 {
 	struct se_dev_entry *orig, *new;
+	int ret = 0;
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new) {
@@ -329,6 +330,12 @@ int core_enable_device_list_for_node(
 		return -ENOMEM;
 	}
 
+	new->stats = alloc_percpu(struct se_dev_entry_io_stats);
+	if (!new->stats) {
+		ret = -ENOMEM;
+		goto free_deve;
+	}
+
 	spin_lock_init(&new->ua_lock);
 	INIT_LIST_HEAD(&new->ua_list);
 	INIT_LIST_HEAD(&new->lun_link);
@@ -351,8 +358,8 @@ int core_enable_device_list_for_node(
 			       " for dynamic -> explicit NodeACL conversion:"
 				" %s\n", nacl->initiatorname);
 			mutex_unlock(&nacl->lun_entry_mutex);
-			kfree(new);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_stats;
 		}
 		if (orig->se_lun_acl != NULL) {
 			pr_warn_ratelimited("Detected existing explicit"
@@ -360,8 +367,8 @@ int core_enable_device_list_for_node(
 				" mapped_lun: %llu, failing\n",
 				 nacl->initiatorname, mapped_lun);
 			mutex_unlock(&nacl->lun_entry_mutex);
-			kfree(new);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_stats;
 		}
 
 		new->se_lun = lun;
@@ -394,6 +401,20 @@ int core_enable_device_list_for_node(
 
 	target_luns_data_has_changed(nacl, new, true);
 	return 0;
+
+free_stats:
+	free_percpu(new->stats);
+free_deve:
+	kfree(new);
+	return ret;
+}
+
+static void target_free_dev_entry(struct rcu_head *head)
+{
+	struct se_dev_entry *deve = container_of(head, struct se_dev_entry,
+						 rcu_head);
+	free_percpu(deve->stats);
+	kfree(deve);
 }
 
 void core_disable_device_list_for_node(
@@ -443,7 +464,7 @@ void core_disable_device_list_for_node(
 	kref_put(&orig->pr_kref, target_pr_kref_release);
 	wait_for_completion(&orig->pr_comp);
 
-	kfree_rcu(orig, rcu_head);
+	call_rcu(&orig->rcu_head, target_free_dev_entry);
 
 	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
 	target_luns_data_has_changed(nacl, NULL, false);
@@ -689,11 +710,13 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	if (!dev)
 		return NULL;
 
+	dev->stats = alloc_percpu(struct se_dev_io_stats);
+	if (!dev->stats)
+		goto free_device;
+
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
-	if (!dev->queues) {
-		hba->backend->ops->free_device(dev);
-		return NULL;
-	}
+	if (!dev->queues)
+		goto free_stats;
 
 	dev->queue_cnt = nr_cpu_ids;
 	for (i = 0; i < dev->queue_cnt; i++) {
@@ -707,6 +730,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
+
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
 	dev->transport_flags = dev->transport->transport_flags_default;
@@ -791,6 +815,12 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 		sizeof(dev->t10_wwn.revision));
 
 	return dev;
+
+free_stats:
+	free_percpu(dev->stats);
+free_device:
+	hba->backend->ops->free_device(dev);
+	return NULL;
 }
 
 /*
@@ -1001,6 +1031,7 @@ void target_free_device(struct se_device *dev)
 		dev->transport->free_prot(dev);
 
 	kfree(dev->queues);
+	free_percpu(dev->stats);
 	dev->transport->free_device(dev);
 }
 
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 210648a0092e..0aafc900c3aa 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -280,30 +280,51 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
+	struct se_dev_io_stats *stats;
+	unsigned int cpu;
+	u32 cmds;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(dev->stats, cpu);
+		cmds += stats->total_cmds;
+	}
 
 	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%lu\n",
-			atomic_long_read(&dev->num_cmds));
+	return snprintf(page, PAGE_SIZE, "%u\n", cmds);
 }
 
 static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
+	struct se_dev_io_stats *stats;
+	unsigned int cpu;
+	u32 bytes;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(dev->stats, cpu);
+		bytes += stats->read_bytes;
+	}
 
 	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%lu\n",
-			atomic_long_read(&dev->read_bytes) >> 20);
+	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
+	struct se_dev_io_stats *stats;
+	unsigned int cpu;
+	u32 bytes;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(dev->stats, cpu);
+		bytes += stats->write_bytes;
+	}
 
 	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%lu\n",
-			atomic_long_read(&dev->write_bytes) >> 20);
+	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
@@ -1019,8 +1040,11 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 {
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_io_stats *stats;
 	struct se_dev_entry *deve;
+	unsigned int cpu;
 	ssize_t ret;
+	u32 cmds;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1028,9 +1052,14 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(deve->stats, cpu);
+		cmds += stats->total_cmds;
+	}
+
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%lu\n",
-		       atomic_long_read(&deve->total_cmds));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", cmds);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1040,8 +1069,11 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 {
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_io_stats *stats;
 	struct se_dev_entry *deve;
+	unsigned int cpu;
 	ssize_t ret;
+	u32 bytes;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1049,9 +1081,14 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(deve->stats, cpu);
+		bytes += stats->read_bytes;
+	}
+
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-		      (u32)(atomic_long_read(&deve->read_bytes) >> 20));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1061,8 +1098,11 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 {
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_io_stats *stats;
 	struct se_dev_entry *deve;
+	unsigned int cpu;
 	ssize_t ret;
+	u32 bytes;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1070,9 +1110,14 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(deve->stats, cpu);
+		bytes += stats->write_bytes;
+	}
+
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-		      (u32)(atomic_long_read(&deve->write_bytes) >> 20));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 97099a5e3f6c..05e3673607b8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -669,15 +669,19 @@ struct se_lun_acl {
 	struct se_ml_stat_grps	ml_stat_grps;
 };
 
+struct se_dev_entry_io_stats {
+	u32			total_cmds;
+	u32			read_bytes;
+	u32			write_bytes;
+};
+
 struct se_dev_entry {
 	u64			mapped_lun;
 	u64			pr_res_key;
 	u64			creation_time;
 	bool			lun_access_ro;
 	u32			attach_count;
-	atomic_long_t		total_cmds;
-	atomic_long_t		read_bytes;
-	atomic_long_t		write_bytes;
+	struct se_dev_entry_io_stats __percpu	*stats;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	struct kref		pr_kref;
 	struct completion	pr_comp;
@@ -800,6 +804,12 @@ struct se_device_queue {
 	struct se_cmd_queue	sq;
 };
 
+struct se_dev_io_stats {
+	u32			total_cmds;
+	u32			read_bytes;
+	u32			write_bytes;
+};
+
 struct se_device {
 	/* Used for SAM Task Attribute ordering */
 	u32			dev_cur_ordered_id;
@@ -821,9 +831,7 @@ struct se_device {
 	atomic_long_t		num_resets;
 	atomic_long_t		aborts_complete;
 	atomic_long_t		aborts_no_task;
-	atomic_long_t		num_cmds;
-	atomic_long_t		read_bytes;
-	atomic_long_t		write_bytes;
+	struct se_dev_io_stats __percpu	*stats;
 	/* Active commands on this virtual SE device */
 	atomic_t		non_ordered;
 	bool			ordered_sync_in_progress;
-- 
2.43.0

