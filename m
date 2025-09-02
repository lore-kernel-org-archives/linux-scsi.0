Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013030.outbound.protection.outlook.com [40.107.44.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3B0313E04;
	Tue,  2 Sep 2025 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819494; cv=fail; b=pWFFR72Pdd8k/Dixlpr9yY5aKP0nzrh9SHq9s3QULIBmv/O66NUBqPe+RDsqI5YZ10/Up3QZ6G21LrGY+Ya+biOe+Yi4RjW5ANeM0NY9i7dTVu+Pc3r+NKHd4OI4SdPqTRh2hJnlXva9pd3XyYBoYutPN2Xvwi8JyLFl0aQqaC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819494; c=relaxed/simple;
	bh=w3kcDBtAS1rIl3ZvQImc+S7O+FJdOX47WXu61//cAdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B2dPUUtx+9ZxXnzsiXQCFHl0Rk7Pj79vF3Dmv+IK5iyPVs040K8NhK2ZI17X5Z8hFh9zD9Tpmd5hPXM4KQ7xQeAdbtSeqWRzqAI2RcRehBB7IyZDBjxJC5fQXfGK9QcNTvPf4tNYbGB2owF68EnXLnYZMcTshr3/axNsJ2ZC7kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=gxfDUQ1N; arc=fail smtp.client-ip=40.107.44.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="gxfDUQ1N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VXr19CAYmDJSeD3Xg5nSsMpq++k8w/xEl2hFn/EPXw7TVfgLi7Y34Iae9MOFjzqK21PSekO/m0/51t5su1dutbWvuOZvKzOdvRJXCq9XXG8KtvXcs+OUYonnT4YXKpTrFUJGX4giExeKgS0sFy8kOm4XFmEs/BwLrl93SeyHd27+pKp7oPnK5axBbQ0o+KPsgSp5fGg1B4hQg8J1MW6ycPbCdV3dwbpNNo16LsEl/TQhp8q5jR1A98GP4/B213SXpmN9yEXUhmPlK3mBKbqFFGoe/5LPyiryu/pWuofEakKXP9aXCgVlowh7rlXER+JwHVxa4xnv7jIbvpyDGtHvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIVTjWO06zXGjX/ib1VEXgEB0POxe8EefiC7YZlKgxo=;
 b=DDRln/y9eXpe7dea8silevX6EWxHTPwAGKigyJg5mIrjKdGTeedHexKWGPOXFE6aDwWxlS6uLJiOOdH3T3uBZLc6LV8Ch9gEFCn6L56A0xu08neXhAkDBIA12EpRiHoSVsHZ5OsFDz11CpfnCzZr4X8t2eq7kTuZ2FChGR74Kka2R9NnN+AEwLAP5TsWYTPvnZv7GKhp7YPb+OrQGctYMesfrjviNZBqy7Tj/lFPwMus9na65b4siCsU8eVTMDiPzrcKPUhVC13Da7oF+8UY8awVcXVJlpOCe5z3hG+BdrZeYO/I+24jyl0VS30BIwWZg1X7vOaNbLpfAtQL5wyCAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIVTjWO06zXGjX/ib1VEXgEB0POxe8EefiC7YZlKgxo=;
 b=gxfDUQ1NL5Zo9m1oVeUMKj+L0sxocGn76Yq968mTUalWvT7yPsk0anYqCVIjkPMTaqPbvFdY7OrUzQ7/1dDmn2K4k9UKJHm8hYVcES48jWdM4fGyrWIP+HgB+UzTlSG7VaXtE8NjLoU2OwNqQ2MM65wI3WI7K7RN6yfMe0Lewz0tXH5hW6FmTdtU5b/krwYJ+i9DqYBmRvK2sKdqDk5VLF+2LNyzS6Xr72C4zL6ILy5vQxPmr1bbgJfvF1ysMt8KIrSfURwrjTTVS8wEzDf5IzDZhYrmR/hygghMOHS4TlUP6myWeLIpvW6nfIPd/gqW6nuzl71n2qBJyxvLqAG67g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TY0PR06MB5078.apcprd06.prod.outlook.com (2603:1096:400:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 13:24:51 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 13:24:51 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 5/6] scsi: scsi_transport_fc: Remove redundant ternary operators
Date: Tue,  2 Sep 2025 21:23:45 +0800
Message-Id: <20250902132359.83059-6-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250902132359.83059-1-liaoyuanhong@vivo.com>
References: <20250902132359.83059-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0238.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::11) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TY0PR06MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 04fecf67-c33c-4aa9-d896-08ddea2418bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jGU/L7XiLqa7nN3Zse4a07U0R6N0F8dGn8irsE4diCKcbOCfMLNCnWqTlPd9?=
 =?us-ascii?Q?fP+F5TD656ghbYshM4l2oy24R0WmGlOdnrZfP7Wc52X7Lb57g+/1OB6R4Azh?=
 =?us-ascii?Q?cagFriYvc2jBLJDxkoEBBL3JKaj6CGRo9z2k9zGcDam3jkf0kWE+49LphUlX?=
 =?us-ascii?Q?sB10d74KA5udr6T/OhyePJFCr+uSHF5q5UDPGG7TZqxpPv1hcXdXmncXbKtS?=
 =?us-ascii?Q?r9quSrEY/3Pk3C27BkLhqvc0LVAD0oa5dCwrZ7idPr00TWwL4zkIOQ+75HgC?=
 =?us-ascii?Q?h7bttlB4QeXrEOdzlPug6o2xvry3IExV6KSI3UJd8geD8ybDvkSVbrNlEe1w?=
 =?us-ascii?Q?T7B/0uY2WWJdDEj46otq8m5/BxEBspnSPt1AUva6/TPlylyv64ntBjk6HEkc?=
 =?us-ascii?Q?RrqtWT0Ecu4B4TvzbqLoSWzXh6h7xW8bcZ7mBykAPjsbD+hI9/nq6XIlut6w?=
 =?us-ascii?Q?bfnq6lQv3QQyb1zxZqi/n3OKfWm/5E63zKiKbNqoFwxpeMHqwjv0neDGBb2i?=
 =?us-ascii?Q?DemkkTRFuzhRz6RK8VraBSlEaKTXZgRj/6ae15QUwwDsjtLLJaYxdNU30bwG?=
 =?us-ascii?Q?PoREP1yqJPZis0Y1qI++GTXKvSY4i43Q32t3hMU4oaJVyT22nlcXWNIpKjos?=
 =?us-ascii?Q?rrWZDq+Dx0UWc3cFcHtWk4C39jI2UfnG/ToNuMZbSgL9p6c1S3MyvOcpVlhI?=
 =?us-ascii?Q?No97guDIzxJkxz1MGYji581IYCcsg7TJaPSm3v52vFim6siofPzDwDqmkwq6?=
 =?us-ascii?Q?N3688377GGjM6Vfcad1F+QMvA/Xnk4w3bLH/+QrtBZmiGF2ByjTMjqLNdp8e?=
 =?us-ascii?Q?OsKu6CgQ8W+n0EFOzOW6I66gz7GIKDL+E6c5k67UjwH48Xhi3HcUvLzUWWJm?=
 =?us-ascii?Q?+trH/98Lgfs56R7y4hffMLOTWg0pWKUb8ZmguGPOAxsp83iJL2jvOahZqw34?=
 =?us-ascii?Q?r0dQGeA31RVZtfgXyFSJ5a6EMf6kMFbJzW08uqMQawcxJVNcl36MAxXsf+d8?=
 =?us-ascii?Q?dvqni5C7DiOzt9tAEhRcm6ob+vcOXG2OprqoL7HKH0tZMneMamNkGH/Ia+XN?=
 =?us-ascii?Q?Gp07xeReWNxlt5ZPKHNORBKY1Yhr+o6FMzkLXGTmr1YIWOnAwrIGNMWsaI99?=
 =?us-ascii?Q?UdfYpZ1eqWpPcd7p2FsMndPw6MEh54RqGjdK+YZtJjW4V2oXGJeQpnRen5sP?=
 =?us-ascii?Q?i2nZnea8yHBCRMTfWNEoigqzx0ePAcovqRT8wR1vTPAT0ifHvWa57B4ZNfif?=
 =?us-ascii?Q?vyBiWwcPXlSSxOHTi57oQDX9SAFq1msCkrih3132FGtZVE1M1gupXGzez7iY?=
 =?us-ascii?Q?+sBdzVf6L23AH2PQq3iA445rbM3SmVg3OCBLPtDb15gmheWMSz0Z1Hm2DAeH?=
 =?us-ascii?Q?6VERoud7g1F66zzJqCsaNB6jmJWywc+GGNHOVoCGIhPLZijsTyjnI5QzqZQz?=
 =?us-ascii?Q?W8Ry4quTvIYGFypQ3vGUYVttQQxH2idZsOZ3SUke6wXzbJFqK/RBXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oRvTtX+ytyjAg4dP/+HQkWLF8J16hnpfu1Ju6GViOp38GDFn6+B/mojAN63C?=
 =?us-ascii?Q?wvDxtJe4scca/lVfFmTEdXYCTHZR1Kp8eEDuELxqTN7yZZs1oRK/C9RoV1/s?=
 =?us-ascii?Q?v4AtafAm8a/xXNm8dfp8AQzrxT0yjMbjadau7mKo1aOBHqyZhQcRlSVzub/S?=
 =?us-ascii?Q?Q2Yag0E5PGUam2kS6eZF72lCQcdkNM3YCmIChIdeJpPxjPHU/9nQB6qriDQd?=
 =?us-ascii?Q?PVaL0MxxWLh9EAOcd0moLBXqKG+sHpcT++eAA5uNRYA9uB0779mKkgxDXxit?=
 =?us-ascii?Q?RKL9gEICBXJDDjKpzaA/6ZUJwnZ0CLWh6QBl+qUWjAl5tg1j0BHW/t1RBrts?=
 =?us-ascii?Q?Hvmts2nkVh4npPI4LOAZwuNebtlaGq/6CrXqy+t/eMX/+8ETIBzOOs43oDp3?=
 =?us-ascii?Q?iKw3BSjmVfCqnTZTxtLTNYnGPDDWvEehDx8fviSvh5Urk+XgtzEOaaLyobHg?=
 =?us-ascii?Q?5mMM7RPv6axxlZs0wxUwLmrVVjtSNpuhAHTsmJQrsEU4LoD4kxlxBQ9pDwad?=
 =?us-ascii?Q?x4jboZQEo6R+s9/wIRNe1jkgZzN+OWwfLeohU65KqAdf8sBpV/GEFSQ1kmCC?=
 =?us-ascii?Q?OgxlOtSIrh07jGq6iDWJ00Z16Cu79uQLI0nPY6nrafjQDn3n6GOjuLmZ69w8?=
 =?us-ascii?Q?wXAKVfi3mrofdmsN6Ua29SMNcuE8LWGWmx87q/dbcrETDK6OCilPgS6Dtf8W?=
 =?us-ascii?Q?Hc0cYhtlPcODZB4za2o+lf8Apn7kic5ZKRLXipVvMfHm/svhKDQ/xffI2ftQ?=
 =?us-ascii?Q?5AZZPpaW1NW/Cv7K/KV8+sKgLji9k4lO5qqNpQE3VrgGv25MkPLv1B1J9BXq?=
 =?us-ascii?Q?0QD8Am/QPEUOd1Xt89wcEZL3yilNSQLNqaB2ZVX6D5kk2ncFtryg3NWfIaA0?=
 =?us-ascii?Q?dL9STny81Z6Hr0DCQW8HK+uAf1Wm9qZQ09lX1Q8k3R6MmrwECmu4sRnleDLu?=
 =?us-ascii?Q?p+EaBBfX1lO7zBn31xyf1R1Sy8ojBbnkmJfhJRV7wrRE3yGWlVQ+pKMA+l1e?=
 =?us-ascii?Q?7UNc2kCc8WtQSxWgdDrTHVMnXsb4i3665nQCLhCJMdUWyu4yGI790hEFCkh9?=
 =?us-ascii?Q?wcPLsQ6geBWiML8jJyNA601doSPWq3z10e4/mVtWcZoBZh5d2DpEFGOmYpuP?=
 =?us-ascii?Q?m4SGgIvy8GHMG39jM1scB+hg9tOMEU+8i12a7eDDtdrfRQ/Dpf2zcYwnRPVc?=
 =?us-ascii?Q?4TSR3vJo0LQW9MfPz5h7MJdgWRYLH241yjpXfQoWmgHY9mUT2RacebsUKoOx?=
 =?us-ascii?Q?JrSFT0HatFty+AJ5wF0sjSvbNVueH6O4KjXj936kJROwiat2ASj9YjAclX6D?=
 =?us-ascii?Q?O3obbNHawc51b0XHvfvxR5qRzq8rDuT7jhSb8hpF6cmweni1SW8Ns4Zhe9uX?=
 =?us-ascii?Q?G2wdYk8bzw40QtTo7f7GHWinBoamkLrl0RkMkKrMw10a7nPdrdhT6VwAIQY7?=
 =?us-ascii?Q?VdSokWljwNXkMJHwwrraRfC+du/X5hoTD4TaRvK6P1To67Atrr09ErYUpwSf?=
 =?us-ascii?Q?JGfM2oGmHOo0iQH14TtKkSgCu0f2wwrCu4RXkQeKy7ZEMGNSbLhvzkpB+l1T?=
 =?us-ascii?Q?r7VjF4bkaDZvWb3hTDUwV2RZpee1Dv/aR5Im5o3X?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fecf67-c33c-4aa9-d896-08ddea2418bb
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 13:24:51.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zaa5VRfFh9cDbN3ikf/wTpqUu+9kfBIXiADtmFswQ5vuJtbiBCtWrau9E2VsVtodbmqmAI3ZW7drHrlLrxSzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5078

Remove redundant ternary operators to clean up the code.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3a821afee9bc..a5a58ec25c91 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1712,7 +1712,7 @@ store_fc_vport_disable(struct device *dev, struct device_attribute *attr,
 	} else
 		return -EINVAL;
 
-	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
+	stat = i->f->vport_disable(vport, *buf != '0');
 	return stat ? stat : count;
 }
 static FC_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
-- 
2.34.1

