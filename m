Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EE42F83CF;
	Fri,  5 Sep 2025 07:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058911; cv=fail; b=HPiqzJy/P8/zpAv/lWYND1Sp5B33CTrBoOgtOWZNxzNKRawrMJz5MC53+bivpMxQAVG8qRY42YXOPXqtfgcUiWKWUViDFfpBjQnOPlu2vuQBZS/pn9fz6Tib8PuOubH8MtJ1uOi5Nu/NOtpIerOMrrDSGT2ltaoJRBTfz5OdWQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058911; c=relaxed/simple;
	bh=VYmdnODqy9EiDqDtPc1SZ5+afqlVW6OzHBO0nYTO3FM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c8wqHUM1ql6X1MsF4YQ5AYJLwqudbOa7vjrzoI4CGLgJTsifLuicy8R87ItZ/j1a6B5Tl6tvx3A9fRtazoOYGCxbAEytHx1TZMd9DFYPD1Fv4m0IYsK3+kk3aRIl/jjOib0wmos788G3PWEFm+MTpqj39SCjcr7CQjW+b+I1DIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=R+BfVGi0; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="R+BfVGi0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LZoMGBT+DelS9/CwcRQRnY5FXH2QIs6i2New7D37Xv6jKF97IL4ZXhaNh9EXWUt8dox39WRvv8abrtFJV49dbT3D1iKbiceE0hIvs7oyY1l6mL9jK1ngvY021yAvWBIg2v92rVqNWy5rLaT0o7n2EYuFXgmk8LRucwCtj348OPO6PDy2UEHHxBcNWBjM5+5huA0WmLWdg8hwWpVw1oSVKOUiJ4mnz90CSSSc2eJe3Z3GGU4gghBs+FKZKboWCs3SThgkykKu4j7GouTVJOxrnbaMOxZHnFwrFsSMr+9lRgYapU7LCH2XGOhcLRwbW4MTdazDpfEaPB/HzaRGnf3wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWZLA07M0Iph8xDVzin5fyocJKDYyrL15SU2nVGSFcw=;
 b=YUcAszXO3DDx/M1FTZ3dHsAFvmTdB5Qt5Wlu5JP98b+XnyCn0jIE/enxyuKuBKfLHq5Iqw1MK4zbUVz44TnXFb7M1JlHuiKulbahwhYyZd56nNorzl4aypPMi/WMgCWzSuCB6n3KLthenf/bDJteK8oZU0cNQr2Ev/eVVxzmPyDZJ5bjkdKDTYQml9UAFAideen9AHDo5iYSU2b1C0aypLIsus4b3z6jUpSemwXbDWaSXlMdnfl0ZmEOm+KjCY3xD2Ep3MOHA2We68My/X2D+rz4z+zrSlqdC2HWTF2Xt2/YhHzTxyVYh1Kt3k264fkaiiiw9l3hU1NNtT+fQHeQzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWZLA07M0Iph8xDVzin5fyocJKDYyrL15SU2nVGSFcw=;
 b=R+BfVGi0af4b1VBhpJ4dtpJlu/NnaPimxiukGqI9oepRoALVue1Nbp1QLyXxMDZ32ltr+AUNWJwM9SVfInuhZrc1GroD0e/cTeGnDMkOwIbKoe3bWxD4s6KKfIPrAxoqotJmUUUJ/KLFoY85TcwEJDtJJlG1Oj1jU/FTfGwURCEVWB//CuHkLygmXCdxu+trftI6FnC7YI5tctvnWvwdZmDpFckwb8iClviYnrkT1T3CpANwKI/dfDIMjdQ9ZMOHXJkGP2AaVpgDWV7sCAK3NRYk6jbc0EJUDPOI/6oXV0UTvAMEOxlV+66PTf2uUoG90SQ0MuFEmpuhPpCZK8SsqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7282.apcprd06.prod.outlook.com (2603:1096:405:a1::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 07:55:07 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 07:55:07 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 3/3] scsi: qla2xxx: Fix incorrect sign of error code in qla_nvme_xmt_ls_rsp()
Date: Fri,  5 Sep 2025 15:54:45 +0800
Message-Id: <20250905075446.381139-4-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250905075446.381139-1-rongqianfeng@vivo.com>
References: <20250905075446.381139-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0244.apcprd06.prod.outlook.com
 (2603:1096:4:ac::28) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: be6faa07-9858-461a-e711-08ddec5187a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UeoNsfeCelVedzlT4KEgQGn2ZLMqeo3gHEcDE4T/T5eh2gFYnQaD5B4qgv89?=
 =?us-ascii?Q?ua8IIqhn3LktuOMlsXuXvtFLlGmsCqgM+JTTvd44qc1/sj7gSWJ0c1XHVolU?=
 =?us-ascii?Q?ij1xp3fepuJYf2tmfckdzACnxgj7JzUoci8qboiU7S6sr8EOogkEgJVh6yKN?=
 =?us-ascii?Q?YgOjDbc5gorxZ5kPHgmAWiUOh5H/h3uXjpHRodFL76gGAjfAum2m76kZzXRP?=
 =?us-ascii?Q?hhyghv5SYuRHxAxMdYhYFvyBbxRUbxu5ZyFnkBWuQfyVsssfegWf1NIc7xIj?=
 =?us-ascii?Q?Bapp32XWU/bvNbOW+s0WrpAlQR6d/gNYJxbam0vGl2lcXieq/cv7k3wJW7kV?=
 =?us-ascii?Q?F09vjzjCJGq6Xn3Yf9sPV9UPdNQKau+Y9SFlUXRmOebV33wLZsbqgPm+qS4O?=
 =?us-ascii?Q?MC1JxV+m3shg2t/idrD0nZ/xo2fwjrHjwcxuLxs4QRaAekgSLRHPSZqC2Gqg?=
 =?us-ascii?Q?1jL1kv0vMFn5UcPjOsaWpcAg8rnp41MtK5WJ/s9ogK/+piXEOxT0d0Hl07lQ?=
 =?us-ascii?Q?/qPk9yNM1Sc89pxAa23ZvtYjlRjt18a2mVBwu8fS9fpfBCsJGqRXYyO/VwZd?=
 =?us-ascii?Q?EZTKyRBr5BXIF/8Wnh4hIzFMRAJAqTVAcJKWzl2TEKTZL7sf48oK2mXQeKft?=
 =?us-ascii?Q?nTBOI1gpw8AJxxBMKMjWSAegKhWJ6EyH6qCW+VYYBz6LpEGemWsnJuHZVYSx?=
 =?us-ascii?Q?l+thZWpbD9rjuqXLIGsLwpEfj6g93hXs3QlNxHEnQY+5oN76nInkq3zC+64K?=
 =?us-ascii?Q?ObO3mn1I24Qy/zf7owHtM7+kFAho0u5ckcpJcNsN3Xm6CpRi3znOX07OMsYg?=
 =?us-ascii?Q?96G80vQuvmpH7iQy3pLPEoduSS5Bwsav/3tBo2r61WTw7/PxRCN7OTf9Ydsn?=
 =?us-ascii?Q?Y/tOUJ4MbXqWppLrpmtLHztG6qLtzWoVe8Yoz70xrijI7DTc2tzKRmV0vnIx?=
 =?us-ascii?Q?ZPTybn5kD7QC7LQwZn7cEU4BMokO51Dah42VyReDBll2Qq9eEAADbKFdg7tn?=
 =?us-ascii?Q?ZdyKxQF7o/8txktCnusvTxN5l0Q1ocwLAQrUyh85TFphq5NKao07SNkWjdM3?=
 =?us-ascii?Q?zxYjcUODmmdhvmX2BYZtL7/UTeMAOTXhBbiimrR93ZineMrZM6sxz/79onkP?=
 =?us-ascii?Q?AB7VWu3/tkNl/4oFwfgaZgcYQ8GtEgn6RunkuEdGh3swu2XNezhOaKP1Zr8q?=
 =?us-ascii?Q?LTbfk1aWRsaeMDdCKRmFYBfG/dCPWC7vSu+YIz+vP/2+/PaJ0EMPq3MQo6Lq?=
 =?us-ascii?Q?mgrJ9ti4zvOrxbT2yu2L6eX0aJEgGvHGvo4+v1dciuwPXWmkEJCwq7NiAxqP?=
 =?us-ascii?Q?1CUK5hkvaLdze9mRSX1XNIynBBOO7rcVo4OMDD6F19lhxNA+eT9QTJORFv4V?=
 =?us-ascii?Q?xR/rZNzQcZnDrKdocgV95+3i/eVekz+bvdmdsg8GvOsgnMWkkKcO4w2DtjIi?=
 =?us-ascii?Q?sTc1a9YDpzYS+odWrVvAL/hzk/viRDvahvThyd/ld9BQgk/beVHK5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0oiegjujXfc4Pa1Uo8owPAuUivl1i1zy8LwBuny3kWBrdMXAqivGiygFgm0p?=
 =?us-ascii?Q?te2omD8NqY4+0+M4IIujhv0YfeeRvnDx27UA44WLA6Q0W5QQ3MYYATT49p7k?=
 =?us-ascii?Q?lNHadPc0ikNaorIL5Skm2+0ApVGaw5mMb3P8WnFrFpcVzmzpEvz3q33mWlWh?=
 =?us-ascii?Q?zdN338rfvLI3JuDTHXfKQD3nH1QxLSlndKalgP3wGd4iJ/cXjaZQP6FmdWDT?=
 =?us-ascii?Q?COsIYJV6Sy/edRcMItF8i5GzzOOL/uSclIJcX/c/p/UDtG/r0gMbJuMXTh/M?=
 =?us-ascii?Q?IcZ+dk8RzDFg2RmN7Bjf7rpLpYu0UWUaXpZGQafEdHQBmv8OT5ZUASv/qRil?=
 =?us-ascii?Q?F8hLP6mUCctIiSg6eXRMCdwa1o3ZNwhSCcveVz5d/9t8gAXLs3EwAhYxuFmh?=
 =?us-ascii?Q?IU/9LaIO4imXegKrqn6LuSBcIEHuTsjth89XSdFFacOhZuDeZOu3B397nL8J?=
 =?us-ascii?Q?gAK41auyT6fJAzecTeyTSNHP2mGy8TqA7GjX041QFFB3mC4y5KZbEfYvg0Ux?=
 =?us-ascii?Q?SmeoNEJYZ01MKuE98e1/dVQDEULjauZFT+Ykw3mLsdRTpNIy9byL1WRu9zLt?=
 =?us-ascii?Q?cqY8wqkcYLIxikl2kjHq81y1GqYCdK7yMOsuz/kGF5zXnwwqkKhI6gbVzs8J?=
 =?us-ascii?Q?lC7aDVNO4MOjz/1/vAkJZyaHPB+g6qzWiHgZLHuOe78TCAJ4I7/FX1Nqp+M5?=
 =?us-ascii?Q?GEKU/UuLoWCJGAS2xxJjbjqn3LycRKsnzDfNDwtd6RpDPTmotG4rDMTE8m1O?=
 =?us-ascii?Q?2itZRSdFkzbhIkxeHvStq1HAACq9SedpnqDRWnSxN1Qoq9IEh0LYFI4h08uv?=
 =?us-ascii?Q?K2yxDVAUnl37zfOiV4dGVN17hzFt8ezcAS/0HYV2qVWbfEen/DJg3Ue43QY9?=
 =?us-ascii?Q?S8C+9B4es9Ui4dE8YWZJGkAA5DPtEOh0f6xuGDbYnJlziQqz+bJybvuDCxu7?=
 =?us-ascii?Q?KUycNi1tCuDfQj0seXNzL1k51OA31XuDIH2iahVwVSVwQdHzQSO437dsaHep?=
 =?us-ascii?Q?mbtSm0eUAy6IBE6FS+e0ChwdWXwPq0IjMNIyHlxLBFuuNR6wXAr54Cz2ab6e?=
 =?us-ascii?Q?V41ddueJ4WTf8BMmpJQv4R7hsXk+WDobzxhKY9tsD8WN79+cG/HI4v/mjSIq?=
 =?us-ascii?Q?YvlDip6G1CR03e39km7x2bW+Zvtk8S0gjdZG100F5VTKiE1xPxW9thWHOYen?=
 =?us-ascii?Q?0u1zCL/FrWHsQgNPNmGOZl1rxM9b1YsTAgrr3C+efZuzOIMcdgdeO40wPT0Y?=
 =?us-ascii?Q?3Uw3LMhXcfW8dPwSlZxO+/BB5W/QUzZvqLJvLg871JDjWhmTm7Eu5S5288c1?=
 =?us-ascii?Q?vy0l8Fng74s19nHckHzUQ8l2yByDIN5ZP+zM1I4Sf2qQKggbZAz5z0KLYzBN?=
 =?us-ascii?Q?EXcsIR2jiUlg5OVEwuvddAsoiGysR4FYgwTmkefsLAJrmQJXPUDH39Qu3Pj0?=
 =?us-ascii?Q?WGuDEMN6clzd8LuBbBuY4Kj/y20LjtooPq7UVa1f+POx4TCj/XS4pUzc1FSK?=
 =?us-ascii?Q?/UMoNlO7nrE17sSCPrGXUeog0QsWOMXVxFlGBWkVNUapQ6t9rz1MgrzKrvy9?=
 =?us-ascii?Q?I5lZgbnShzpYfNPQO/TL98+SGzNqtiwCkd61QxvZ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be6faa07-9858-461a-e711-08ddec5187a6
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 07:55:07.0926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnECgyrNmd8EXUFcERY5OgKh118lUQStxhDcDl85ZnpJiIAi6+jyrlAK5GMpnK20npeQkUhslboPVYWTAbyUIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7282

Change the error code EAGAIN to -EAGAIN in qla_nvme_xmt_ls_rsp() to align
with qla2x00_start_sp() returning negative error codes or QLA_SUCCESS,
preventing logical errors.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 92488890bc04..065f9bcca26f 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -419,7 +419,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(PURLS_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < PURLS_RETRY_COUNT)
-- 
2.34.1

