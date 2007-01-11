From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/21] libsas: Use SCAN_WILD_CARD instead of ~0
Date: Thu, 11 Jan 2007 14:15:09 -0800
Message-ID: <20070111221509.3543.84010.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39601 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbXAKWOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:50 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEnfW015268
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:49 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEnWn304036
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:49 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEnae002130
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:49 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Magic number cleanup.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/scsi_transport_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 9e38c18..e57b02e 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1283,7 +1283,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
 	if (identify->device_type == SAS_END_DEVICE &&
 	    rphy->scsi_target_id != -1) {
 		scsi_scan_target(&rphy->dev, 0,
-				rphy->scsi_target_id, ~0, 0);
+				rphy->scsi_target_id, SCAN_WILD_CARD, 0);
 	}
 
 	return 0;
