Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012021.outbound.protection.outlook.com [52.101.126.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6CC302778;
	Fri, 15 Aug 2025 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260200; cv=fail; b=QD5SKVJVw55GRqgpTxTaII8XRvq6Q89bsd/s2kVU7gyXzjW0vUgq3OhA6/DtyHYCCyW6/7rqJ9q+O2hCKrj5m8obT2U6FP1xJAO305wUPVAMUPuGn6+upAqld2J4gqz2w30VwjZNi+AD3HucLe6Cwqk5MbpXHRVxnBw2zDLc+mY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260200; c=relaxed/simple;
	bh=At3NFxec2JPREj2q0+aKalXLXh6P0dXbH/qKPwQvYqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XgKsqNG9f8jLiq522vSBMehWhFb4SsxDZ/GdrlWARFRl83OL8sRquZQ6tVka6DqHfqXJRKWV6a6AEweAbVtwBK6WQsS6ltvB3R/XppxTx6G1QDayQsDc5zqeefJVoHxdpp9HtMpZKQM/5q/y7stALmPmNtGA83rcpInS5IEQb0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=D/T+YVQs; arc=fail smtp.client-ip=52.101.126.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="D/T+YVQs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w+yBKElpUpHT8+gRjqJVT2BHRB7E1mcnDupTDaymDZmyevq1NxVfkkvpRGuhy7Hr18I2KdCoQAWhpI7dIBYj4ma1mqyoaGT23I3FrARA5SLgcwn8euiL/OBAQQwGw/YLURSVYPDXlvezNASjBu7Za86UqOGxYwwCcA1zuGMG4fy41aVzHkETn0QHT3ducjFPiwS76OLwD09kcfIn1sDjHN00cI4dZm6Jbo4hx8wzn7QiNil770TZj5sG1ij54TTjpt01CXk1eopEoDS3FUIHwarJvYLvAedcpVEGxOIZDfhwr2okpPBtRf2CnY0484yQ9EXB80TNDYXl31OHlyOR0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oe8VGlu/z2A6ZQb+J/mOPu9V83/0DQz/hiQuxGh6hCI=;
 b=U5+qw1Wl+evqnq0wJoTMkOWTtJbqy8Uwopbkvho3ZmGaX/6I0Nva0EcIqJia4u7g3V6oDiVGovr1lqHamgO2Q5Oqgh1sq9yCvdtv+kw5rHh3cWYMeyR84Bx9Tmh7PLkS89YhMidCmuQx4Yj8SePmwJLd/t9qTwzdPkgslGzlm4f7DRIXHrntAptmJML4wTFW2E9o63KCq+rGhF0EinQrhwVVz9y1LSdJ2WkXFQy/ieQL/KR/0x8pK7RbmKPuVRLH7FJNIc5keh7phLwOYw4OLzuaatCdphw4SeE1sFSDT/fvBzeISD3TNjJXKXO07s6+8V6LfphtiI+BPVIWAMqvHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe8VGlu/z2A6ZQb+J/mOPu9V83/0DQz/hiQuxGh6hCI=;
 b=D/T+YVQsOJkeg0HP5/wjXoxX4UTiN3R2hJAhYZvdw2dMB3hsLzNxjJJIPwQJo/PDM0b6EbvPO7mW7W/LrOIYORBjtlchPg/pXSA9XLdhldKdF4hgnr5j5HOeLcicL9Ps63KLhs1qRoB9ESiaj+Hyk8YAShwvuKf/udtm8QlKpG3gG+DozpHd00bcjuDBGxvZfm7ctpEADAE57XsgySsr3KyvSIUqQ2wr3/EIxs1TOdYNpqfgbPgFQfE4N9nqNO9Vhxlu3zVEVaxYXByuWbsxuLzkGfu88gEBAKnfjtApNPVHfCmuGfS5kYXvC/Uwy7hddgQFINEuYtefAyzvGSJOlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:36 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:36 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com (open list:BROADCOM MPI3 STORAGE CONTROLLER DRIVER),
	linux-scsi@vger.kernel.org (open list:BROADCOM MPI3 STORAGE CONTROLLER DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 5/6] scsi: mpi3mr: use min() to improve code
Date: Fri, 15 Aug 2025 20:16:07 +0800
Message-Id: <20250815121609.384914-6-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250815121609.384914-1-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0196.jpnprd01.prod.outlook.com
 (2603:1096:404:29::16) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 7411ceb5-74e7-4b0c-8386-08dddbf594a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A0l0TMIWinTEcvrUBmG6I79sfMEf7Yj0NZ6zvaoio9CZluZAKOw1xNl3V9Of?=
 =?us-ascii?Q?YKuVTNwfLghpcHWSWsv/LsGHGOb6G+V26JHueLTjddjvsyV2U2/gVDQQZu6l?=
 =?us-ascii?Q?+ScTYEvsvuy+7lV1uCeM/WnR5Ed+P2et+WoSedmUZYFsIiPO+0B5Na2YkbUD?=
 =?us-ascii?Q?wFQ9EjsT1gI5veJQ2r+zP6BUjI+2zfE6yT98fqBELGEJgTWxoL47tWpFG5Yq?=
 =?us-ascii?Q?TmMjsiYIWLFBQp+Ms3KaGSlbAZvwau5a96pABnX/iJgvvTSvCMa1E+spWqxz?=
 =?us-ascii?Q?79Kh6YI50+S96aoH+Vb1PjCF4PGx5+/klkyDCEXahnmv13jReGq1v+QbDXli?=
 =?us-ascii?Q?V/HNWRLwZPZPx/dLUmfF3WhbHpYd3xgHtI2kkQyAOhN6oqBOcPQuk8P6BMs/?=
 =?us-ascii?Q?4gIq/FbjgLc+7Gx9WXGLxRuPgP+7EWavpIi464K5lah0tK+KfaBQ+zWZk130?=
 =?us-ascii?Q?qTuLwr4dfq9n2OpZFRPngt2C1zcEsnq/yZFkhlwz2TOHoRZ9WeDhXRs84iL2?=
 =?us-ascii?Q?y3Z73o7fbTVKQYBpgMfecrTi80jtK4E9DJMPLp4Poo4WczKuoKXMbQtBVxju?=
 =?us-ascii?Q?2BPA5Ui+hcHGEYCqveP8E3h5ddzB0H5S4D8NCkkBw+/HZufSCwQDhfSOkq8d?=
 =?us-ascii?Q?rbrdGHkzeF/R6SACYdbsxaa4T1qN4/CITADDwX0GOy3WagXzXiSt2ZPPOBbL?=
 =?us-ascii?Q?GfK5tLosEZ8tAWZ2IhY1u2BfmgCKt+38/rysg8tfTJV+mKqi/xW5hfvPF+cI?=
 =?us-ascii?Q?rAFsRrWu5wURyv7eUg1y+VGX/HSxWPGGQKkNp3NHBwWrQEhJ2hNjyaeVB2Wc?=
 =?us-ascii?Q?AmcOTMohGse5PdY+sKP4YkUx4EOdl96Y8asXEh1e8hhT9wIr4GICBBHfHkce?=
 =?us-ascii?Q?lSGNSh/ueNUqHCwtVo7WZVlGT1YRfdAU63BBZGLHxLJT4tPiHzylZm4uLJsP?=
 =?us-ascii?Q?8VruG3m05zhA2C2TFOVU8bPlFzFE8wtNIgWnxCo2PmldbMVo+UGJHYjVISNi?=
 =?us-ascii?Q?gBtOoTPsrs/CxgL6U4Zd/kFdgfY5HbQ2a16okqitus090zYRZE2BnQII98L4?=
 =?us-ascii?Q?MNelwY0/aTwe7Ra9e1/vQvW04A/kQSm12+ee/Rdu5wT9JqTDcxJ2UvHbK2SL?=
 =?us-ascii?Q?vOhdFWyD0IUNQXcSiV2eePYHQQKoHn5KvhrqUorjdLnnpTIurhma4Mfw5F7c?=
 =?us-ascii?Q?8ZJokMjNs2X1i+txySmUsCcN4n0FGhg+PyjuOw+CMAZg4YBhCrLPolAYh+/L?=
 =?us-ascii?Q?jYblei6Y+JB2Sm4NEHhVqxTHipxyET1lldtzBXN016jsFyKrE6mLQhq3yIDg?=
 =?us-ascii?Q?d+jNkGSIu9+XJhsUuopqFZaX6ov2H8+I+r5UTF2iqsm1s6fwLZqSOUnBTYwI?=
 =?us-ascii?Q?708MZI+3Xcv4sL6jG1PjBATG8su63FgJuQbdzA4y3YwyKIerTNZwzzknLs0K?=
 =?us-ascii?Q?oM8eykl7W9L6GiT9CroyZXvkkkURL8IDFhN5dGlFZv8JSAjH96Edug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ads5bvGCESCOAnU4tlZOxJcCaAxOFRZZ+otatWdqgYwsIWkrR4gxAH4ryaAP?=
 =?us-ascii?Q?oHcxQWkZYQcoR+vrxOxmlWhjWCxSzQ6JbZVTMF6rZdZJD/Ab1+SckztCPk/F?=
 =?us-ascii?Q?tSj7G/lRrU7cvE9Iut4hwIRgHpVW+lp72KzrQ1eTUKqzXAjo1ogxJwfafkEc?=
 =?us-ascii?Q?fPefH5LZTO+jRLd1B6HeRssptx1Ijkr3A0Ij1nur5I5Jow98n7OCHTzO465A?=
 =?us-ascii?Q?p+rsxFLofW0VZkVl7fSr16MGOVqmFlZ1am1ONrMlIIWk2oLdarkKWDUd7BXz?=
 =?us-ascii?Q?ftwa3lh+sIA0uX+pEPDLUXN29eYw87ASegsh7yHbL4Jl4f6m9O1ylM5Sb0XY?=
 =?us-ascii?Q?XqOmVRuB2gkqfbfRC2LJJVrZoIcC6fKLtbs9Q8AYMHE8e8Dp9/0Mgg7a+qz3?=
 =?us-ascii?Q?4R+caMwP5g9myY8xuwpMK8PN7tCGkQx9vilExUziEGMiJXYxg+P77EkmNjef?=
 =?us-ascii?Q?0qraf3woHT9lfUWkz3YFyypugQN8sCPTqPY0lmR0zGty7Ih72Fx/a3wYvmHy?=
 =?us-ascii?Q?gtTf3a90JOX1gweCinodgBhzoHNGeiVs88E4IuKy+0wp2hS3LpI1KD24ZqFp?=
 =?us-ascii?Q?Z80nAXkZOvWEYmzpULCmfd3VO5UQm+YgeqRIfT1dL2HRH6sfwY8OpUKwGjX5?=
 =?us-ascii?Q?vrfYqwq/r2y2In9+JtPmpf+JnChsHCWMCaDpljV0pSdfbjPWjbTm0VYCvMSD?=
 =?us-ascii?Q?enrNsFQSn0YeG8Tokc6W1G/957nIs6Dl7SGvCVyVgsjr5Ivp0w311FgCUWVr?=
 =?us-ascii?Q?iLmgVUgTKK3gN1GuJNWJ0+yw6uUAC6cv4ILRDHfB05QRReJL54tZl3KqUUzE?=
 =?us-ascii?Q?qsynvSwZNdCI+gE1iPkD+cc8naHYnEpIM9lEXAuMmZpIzmOyMlqbqliCtl6d?=
 =?us-ascii?Q?/ZpegiSlQzr0WZacLqh4LCoFq/RRNL6Vgx9U5LbyD3rJSWHh6T7y/ghwgQUl?=
 =?us-ascii?Q?Gx7sCVZhPQdeaD/nf4ju2eh/+DoR8Hqby6lw3vEW2ka1lYmOaSOIvAHQ2YJJ?=
 =?us-ascii?Q?JHTRlspiqIzzYFwdKUHlqEaIiQ6eARV00VQqr7PesOhF5FyXTlZ3X9Zoqasv?=
 =?us-ascii?Q?A3pWnJY7t5DnOL900XtthfUtAG5i9C6wkt0ryeVy/Yk9XbEiq9yLBaTbRQ9r?=
 =?us-ascii?Q?ixf0o4i0xHCm5KjsZI1BMJlGFPnSOZzrh2ctDL9rj6IuyOEEepO/aZOZCATM?=
 =?us-ascii?Q?tNXmlAa7L2RE8iHChkypZpX+pCs80S8PI6m+al3T29B1FDOGshufV+0pNa5D?=
 =?us-ascii?Q?hl4oHX7+sjuRELvOC51ie6p4E6LcSJe7kN3KCR4KcMT918kI5JJsx+BjMJ/B?=
 =?us-ascii?Q?ELZg48SsDEQLPQz2V+x1HjDr/r7ZdWq+ohWDEckkfZVrlUNuf6n0ir0Poub3?=
 =?us-ascii?Q?Mwxs6uQof2fZLPTSzUxXVE48vb0kOgZiysk6Y5u4UCYUffwcbtS6+5IZIym1?=
 =?us-ascii?Q?nkumW9pexrBmnMzgbCtax4PTSTWX07HUfwaeyjwMABgVieQgri2BJR2xxqzc?=
 =?us-ascii?Q?lvhAYdb2E6lEUMla5QF/YtAsrLpi6zZCMTY7P5Ebq1alwp7iqzZe3rA2s55D?=
 =?us-ascii?Q?5byFUkjHH8S3RywzC4AN25nmrMHQCVVe6ZmT57tC?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7411ceb5-74e7-4b0c-8386-08dddbf594a6
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:36.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMgvKKRGg3tdP/36qyqW++nwtfVXpSBh/4zIVElzB3BlAzeaVmmBM966TNWNCF5Csc/7ZVfyxcAFTjCwmZMnfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use min() to reduce the code in mpi3mr_map_data_buffer_dma() and
improve its readability.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0e5478d62580..c48dac57b530 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2343,11 +2343,8 @@ static int mpi3mr_map_data_buffer_dma(struct mpi3mr_ioc *mrioc,
 		drv_buf->dma_desc[i].addr = mrioc->ioctl_sge[desc_count].addr;
 		drv_buf->dma_desc[i].dma_addr =
 		    mrioc->ioctl_sge[desc_count].dma_addr;
-		if (buf_len < mrioc->ioctl_sge[desc_count].size)
-			drv_buf->dma_desc[i].size = buf_len;
-		else
-			drv_buf->dma_desc[i].size =
-			    mrioc->ioctl_sge[desc_count].size;
+		drv_buf->dma_desc[i].size = min(buf_len,
+						mrioc->ioctl_sge[desc_count].size);
 		buf_len -= drv_buf->dma_desc[i].size;
 		memset(drv_buf->dma_desc[i].addr, 0,
 		       mrioc->ioctl_sge[desc_count].size);
-- 
2.34.1

