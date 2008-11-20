From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH]  fc_transport: fix old bug on bitflag definitions
Date: Thu, 20 Nov 2008 10:58:01 -0500
Message-ID: <1227196681.7483.3.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48529 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbYKTP5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2008 10:57:09 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mAKFv8Kt023520
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 07:57:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I thought we had corrected this a while ago - however, it's still
in 2.6.28-rc?.

When the fastfail flag was added, it did not account for the flags
being bit fields. Correct the definition so there is no longer a
conflict.

James - we need to get this into 2.6.28

-- james s



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2008-10-18 10:32:54.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2008-11-20 10:54:02.000000000 -0500
@@ -357,7 +357,7 @@ struct fc_rport {	/* aka fc_starget_attr
 /* bit field values for struct fc_rport "flags" field: */
 #define FC_RPORT_DEVLOSS_PENDING	0x01
 #define FC_RPORT_SCAN_PENDING		0x02
-#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x03
+#define FC_RPORT_FAST_FAIL_TIMEDOUT	0x04
 
 #define	dev_to_rport(d)				\
 	container_of(d, struct fc_rport, dev)


