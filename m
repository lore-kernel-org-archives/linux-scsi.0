From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] qla2xxx: sp_str[] can be static
Date: Thu, 21 Dec 2017 13:26:59 +0800
Message-ID: <20171221052659.GA2018@lkp-wsm-ep1>
References: <20171220065644.21511-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22831 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbdLUF1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 00:27:38 -0500
Content-Disposition: inline
In-Reply-To: <20171220065644.21511-2-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org


Fixes: a3e84f0484ea ("qla2xxx: Fix stale memory access for name pointer")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 qla_gs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7e88e828..54c8dfd 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -15,7 +15,7 @@ static int qla2x00_sns_gnn_id(scsi_qla_host_t *, sw_info_t *);
 static int qla2x00_sns_rft_id(scsi_qla_host_t *);
 static int qla2x00_sns_rnn_id(scsi_qla_host_t *);
 
-struct sp_name sp_str[] = {
+static struct sp_name sp_str[] = {
 	{ SPCN_UNKNOWN, "unknown" },
 	{ SPCN_GIDPN, "gidpn" },
 	{ SPCN_GPSC, "gpsc" },
