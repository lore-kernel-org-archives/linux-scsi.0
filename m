Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012047.outbound.protection.outlook.com [52.101.126.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88858286400;
	Fri, 15 Aug 2025 12:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260189; cv=fail; b=jRl24ngFbgYgsdsxK68+nrV9ppAyrIUh2yuf3IuRx9ghxjUBrKiicQvN2J14XXzCsfywneNilXrxXqF9vktqdbj+TfBY1+sAPnxfkjqCYrHImfqPeXozbpnj4nxbOJr5Sg/pFpvPKmN4FsJnf+yyd7DgLySIvL5h8BET27MNblY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260189; c=relaxed/simple;
	bh=IzmLO8BV1TZyY8Qc4TvJzAsN7SuEYmn7A8t0wT1H098=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aXyOMeVArdte5kcHdtfmtXq5HQzPX9esndcixOX66tEwis5AhueOUY9K/egydcEg2s7N/CTSa4rWG4PiKaeeBjh7oET97AfTjzCYV0PPJL98QAaAsH7lh48s6TX3KWzZz/37oQj4qxlF8MYlQAKV7L0B776D9wbMjYt0RZzWGyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=cUGNlgB7; arc=fail smtp.client-ip=52.101.126.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="cUGNlgB7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aEUUA+PXx79k4hqdoVUSAwSVJODlniixUyiMhWHv5KLwJCRE1hWm3AHW62UQ1n0C17o2mR6ed05bqx2QBjsybSfc13ffX+czX3rOLnEGaLeuZrl2l/0/wKeTMpzLgQnqnADPDNo9VwGW1XrY6Uoew0bhn6/GgEfWq19hNVY7RoL7KM7SwxIrUjU0I+/VZ14bSJpv4N4gVkvZHypTh/PNk0DBmtpbE8sLKXSG+dSS4Ph8aKCs/lBwzL21u4vxYlcKWV6jBx+jIfDs9DXQNUfTOU3z3hWe5yHYkYWCQYMq8np8KRpU+m5oRGKX5sb9YBS4w+cnkJMsm49iAR3EIAdljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1dZLkMbsZbyG8SdUoPQA/ggMc4VxD9pp5Dy6ByHCzY=;
 b=TTao7llY8oTa+tBkom+4KqOhQEeBzgOoL5yqmh3xpevN/r08BtYoV3c4H1o/MSJrUpQgB6go4RNY22xpk5h8yE7OYGZp6mjkDdc6zv/B9fYQ9Yf/w4wjvVWjVRpH9OAnVORA4mZ6MK7xZ433ScYCPqD2tElp4qLdTz0D+Nj7JIUZ2Z/pB9Bk7MDtcprIE52Myz2okvZF/U+aSqMY2rrl/P1pBnB2NKhWpgMOiNc2re9qjupBqkSuPpd5Ob+tnnPkCEesucpk+P0slht9s6KywKuxr5C2aJu/4fJOAecDj2hKT2mJC7OWshadcc1Rfye9m/VxlJhK3vCj7kWsAF2ZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1dZLkMbsZbyG8SdUoPQA/ggMc4VxD9pp5Dy6ByHCzY=;
 b=cUGNlgB7tw6n8GURI+sv4CORI4QBdMY/T+5Vj6FveqwKRkCSioZeGMIZqDrxi6bf32JEfow6ZlwEQz+aPuZLyEw1mGBIcTA+xtJ1uu8igiE9rC7rjOXkhS7TpSdOEVmKbYkCIccSBDEPt+c+HFVdKUy5aE7/JqgNAk2joVnOGNinh0gCYeWWYmWgC7vxoDA7tU+OhwPbfhGG1mexBWtRxPP6YSLnRZ2imY7qkTEl2hYO72EhZuZlBJmU8yfZAbCFzOO5S+Sx+VLRmRXiTqtwMVdJxUQKFpo+61UfE1K9ABOi7prEEMzZi88jwwoJ0czeTHEZ19+v86B3U6TBv9nHLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:25 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:25 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:BROCADE BFA FC SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 1/6] scsi: bfa: use min_t() to improve code
Date: Fri, 15 Aug 2025 20:16:03 +0800
Message-Id: <20250815121609.384914-2-rongqianfeng@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 272ce60c-291d-413b-2652-08dddbf58dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dh0tgfRJGUjchaSCEAv2IAg0lnUnBMW7cMjVjiT5Mp1osJIX587qiu+PrMbM?=
 =?us-ascii?Q?VhH/ktUdAXXnfvwlup+TvoSYeYoQk6CAXUjWFKP722v49l7ao6r5hOjiXcVv?=
 =?us-ascii?Q?H1HG6pmJ6SFu9Ct+qHCutm9pat5uLknoVPl8THqr+5S+2abstMEk8AXGf9ys?=
 =?us-ascii?Q?3f+xJyUW2lbJh2iwFuhC9EcHhmFZo5ILCw0/v5wSN6h/4lRAYJOz2y54M67/?=
 =?us-ascii?Q?ZjARJ2JYGQ0NuK56itzGlJ87Q52Jtqks7BQUI6pG+bRbpVXc9tBIIpRGYb+A?=
 =?us-ascii?Q?KuCZNn3hhXF5sQjBh+ZDcL3ZBI2aysXVhAFZCmhU80lnrufkqtEyjGPihI84?=
 =?us-ascii?Q?fl9Y3RKl+96ce9si6ao/CZoMxrkxsFs53sI4+ZfxR5l6jl1dvlTpRT+9XTDe?=
 =?us-ascii?Q?4MzQPgjmG3gV9BQJADa4ZTmCcbiqsJs3rfJRm3tV+st5+oN8U2uIXV9jHUmf?=
 =?us-ascii?Q?pjNBzFs8xfj/FJKe75SZejOEb9nGYnma798pU/24zqRPi/pq3lAHqjz6E2FD?=
 =?us-ascii?Q?sz2IToFxvQ+Io+N+aMUC/dFnFsV6fX6HVw4+N69yVUumaw/var/GtaH1FfFL?=
 =?us-ascii?Q?CC/dywn5QNwPiDbNt8AiOCsmJC4rDn1OiwahOIErfum08tmkr8pYc/CZdv5I?=
 =?us-ascii?Q?xRHV5I6nSnYmsZMCVr94+0/3AKGo15o4nZKcojxB74lZL58jXAXZV06EKTxA?=
 =?us-ascii?Q?02n5wtbL3uBpQ97Cq3TS+Lpm9ZTqmL0XU4POxS65YCXvItrzUr/2GFlzdQO4?=
 =?us-ascii?Q?aCABrCircjGBUG9SSTfOVx2IYHVTNGCcVrqp2kJj/BGexKMebHKebgQNBecV?=
 =?us-ascii?Q?gxqO/IuYEVuHJxVnn79OT5pVBM0A6nol0mS2tp0IPKdyNOWZgBxgod1xKK/s?=
 =?us-ascii?Q?4RsaWG+Yw5cexKotxY6AbhC8VTvqht4op+NfUkLLEVXjjvgrr8pf+/t5Kh6e?=
 =?us-ascii?Q?w6jvYifLm3t9WLln71fxhsbqJv7XKUTsGXuqZ0Xv9kZ5kTV9gjM+L+Og0aUd?=
 =?us-ascii?Q?BDtjq9inwLSfZ8OTMkAiVmY/JNX0y5iT8pmSepWpLcKadVipMqqQpXtSzIXY?=
 =?us-ascii?Q?4vwUWVuI7KNRnkAFWyCTt+tJGjmfe4XJ/oudF2rc29frin9kI4F3yGuDasAX?=
 =?us-ascii?Q?86fq4iEweh2mXv+Dr1fdKeEBbFJtUqHc69NqLY0sHGI0u9O097Ni3nwIghht?=
 =?us-ascii?Q?R8Vo2XR6mNvCWuumuS7FPZi9QBfTSjemWM3kXw/+iT5XpeQvkIzkKndS+gRi?=
 =?us-ascii?Q?uHoXBot2/EcNtSfSOlZYytquTpQpbu8+EnArCz2GBFvbdh5iZCljVIQmEPSV?=
 =?us-ascii?Q?CwXExTBHnAADVLrdGxGOJJ+9Xm2/jfAuUVgofmTu8egmlNo6+4MgHKHkt7xA?=
 =?us-ascii?Q?qppYeDMjZJ3l3DDBMuRNYIO8Zkr/9t5l9v9TDoPPUuz91i3z2fv6bRlVJ6v+?=
 =?us-ascii?Q?noBEcjhP0K4QSfBk+i6czSzWV5u/rgn7c9NqIjDvoSyQPARjnKzGrg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?67FLLNhaIeYbexBENJX3apKc0CXQEcheRZK8u0O29jqZq0ZLMujan5zCZ/Cr?=
 =?us-ascii?Q?TZCvMmu8q6ExHZ1T1+4k7PbX8tWmyr3cOHnRPWBql6Cleevs5aoCrg9dPL1c?=
 =?us-ascii?Q?2HaJkouj1MMb5tNQGPyafK3cLI6TWcRJFZs7WhDID57n5Luj0QOrxYud1Hvc?=
 =?us-ascii?Q?lSoj7pMIGJFH5eUEMZJC6lH32+0wblVQJMMhdLCo1ifrhgOscrJ/kYSDRVBj?=
 =?us-ascii?Q?0ODrTqSQNKpDArJVaWz24Hak52s62UOSuFOx9KdwKuDN4qRcTv41Q76oUQJ5?=
 =?us-ascii?Q?ZW6sWISD27RmbkIqbmYGfHiXemb/xrV8ETBx8tlQ6nYNrDc02L3HRbJPvygY?=
 =?us-ascii?Q?H8P8ppTM1hjhcsU70DbsPj1VswxUBRQLzWItFKZ0x61V8Qw7byRjFG+Vkvz8?=
 =?us-ascii?Q?RQI8TX9T1qmnuYw24DUh8yt6zEoJjeSwDysJRMij2EF9pA4uv+LztGOxsGx2?=
 =?us-ascii?Q?8SzYFZMi5Sh0Gr6l8G42EF4vMVZEHSyZknB8w/OX+/CB/omum5XTZklgzqLM?=
 =?us-ascii?Q?wDbsVUCGuZU2x3F+qpl9byVL4FSBVgohYu6BcKaJvk95C8wnsTlZAwE9MU/2?=
 =?us-ascii?Q?hpaae57YSpvk7uiEC5qtLRyDtT7CT0j2I3/rcNfMWR/yAolmP76VEspcGFR+?=
 =?us-ascii?Q?zR2k7YIEjYw7p8IJ/fsBnyn9mxFt07sAtLlouIs3gLYzEo2dNyPN63XjeU98?=
 =?us-ascii?Q?vSNnLV1Jb491ZP9y2nR23vVXbrgMRXMZ9dMF0zGxAMU+UcwPi3NjdhAuywPF?=
 =?us-ascii?Q?jpacGHXKTZKMhWmeAeQDiuvZaSSCpoj37Fgdtb8FA7mImpNuiqZCjRqWDe44?=
 =?us-ascii?Q?R1qpTV6twkccqRJhbYA8z0Chaa64h0mMPOZValJiXZkDV+HjLhqGzuxx87JX?=
 =?us-ascii?Q?ld4VhPUGqE05XgcBRbmbTvfxVo4qnk0kZ0rQVO4vXRo5EM4g6pw31yg5Xe65?=
 =?us-ascii?Q?e/QH7LP8/djCMVMB7XnJsZ0wzTBtNpndaWFjI4zbT+nLMKFuZtJb0k+FfHWH?=
 =?us-ascii?Q?VysJWaylr4mC3xFqdG7cSVbGUZgbOWFKa3KFc7F6FsR7Lpc8b0/62cGWGiyW?=
 =?us-ascii?Q?7pxrcoN5kO4D9sEf+LS9IC9LQNT8tFqXtBcdqtiwSaUQcHtUv0iaoPR9wM+5?=
 =?us-ascii?Q?1wIEQii/buvK+gY5+6QD0mzaBJaeGLfDbaLz+hJ0y++0lQta0fpaPP2M/rRs?=
 =?us-ascii?Q?N3QvNyWnb9/LL9uA+M1l76qNFaPPDua65rWlRF/ygleBFEwAexG6YRRM53u1?=
 =?us-ascii?Q?4UQ11Jy+WTBssX0VDs8IaKPN3mfByHHHDxj4VPLyHh2OTVr90QuSYSf+S7E5?=
 =?us-ascii?Q?GCJ8TD/BZteAZZPpEXOve1dhHSnsNoYvXQeRBvMmSQqfMJnU5uPZ/Fc0CNcH?=
 =?us-ascii?Q?GoSc8tEkcDYlzVsDWn/nGOEZYZOTFvfx+oXTsPnT1oij2h4gtZfSciPuRPXo?=
 =?us-ascii?Q?ro2bipe+HiklcwisvZvnk1S49+yEDXmQY7bNqMTg9r7pgon2odHGTiuaEnyD?=
 =?us-ascii?Q?wmkuFBINor5/ndD061kIq+zwbhwWwvx0DaMyFJOL395Ve8QDXmdto19hwSqf?=
 =?us-ascii?Q?8CsdCbCCa3MWk5qlissb6whDbXh3jipuVcGbhMED?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272ce60c-291d-413b-2652-08dddbf58dd9
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:25.1354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxmVWT55vzt4CI85JwcCbohXwEnH64ZXJ6zmVe7VyqtH80y2d6xvj3BoLn7f+XV8+AhRuVXDnDwirEWuo1llXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use min_t() to reduce the code in bfa_fcs_rport_update() and
bfa_sgpg_mfree(), and improve readability.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 8 +++-----
 drivers/scsi/bfa/bfa_svc.c       | 5 +----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index d4bde9bbe75b..77dc7aaf5985 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -11,7 +11,6 @@
 /*
  *  rport.c Remote port implementation.
  */
-
 #include "bfad_drv.h"
 #include "bfad_im.h"
 #include "bfa_fcs.h"
@@ -2555,10 +2554,9 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	 * - MAX receive frame size
 	 */
 	rport->cisc = plogi->csp.cisc;
-	if (be16_to_cpu(plogi->class3.rxsz) < be16_to_cpu(plogi->csp.rxsz))
-		rport->maxfrsize = be16_to_cpu(plogi->class3.rxsz);
-	else
-		rport->maxfrsize = be16_to_cpu(plogi->csp.rxsz);
+	rport->maxfrsize = min_t(typeof(rport->maxfrsize),
+				 be16_to_cpu(plogi->class3.rxsz),
+				 be16_to_cpu(plogi->csp.rxsz));
 
 	bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
 	bfa_trc(port->fcs, port->fabric->bb_credit);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index df33afaaa673..2570793aae7f 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5202,10 +5202,7 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
 	 */
 	do {
 		wqe = bfa_q_first(&mod->sgpg_wait_q);
-		if (mod->free_sgpgs < wqe->nsgpg)
-			nsgpg = mod->free_sgpgs;
-		else
-			nsgpg = wqe->nsgpg;
+		nsgpg = min_t(int, mod->free_sgpgs, wqe->nsgpg);
 		bfa_sgpg_malloc(bfa, &wqe->sgpg_q, nsgpg);
 		wqe->nsgpg -= nsgpg;
 		if (wqe->nsgpg == 0) {
-- 
2.34.1

