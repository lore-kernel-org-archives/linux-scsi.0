From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 1/4] zfcp: consistently use appropriate SBAL flag definitions
Date: Thu, 22 Aug 2013 17:49:31 +0200
Message-ID: <1377186574-26954-2-git-send-email-maier@linux.vnet.ibm.com>
References: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
 <1377186574-26954-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59799 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3HVPty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 11:49:54 -0400
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 22 Aug 2013 16:40:17 +0100
In-Reply-To: <1377186574-26954-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

minor cleanup for status read request

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -770,7 +770,8 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(qdio, FSF_QTCB_UNSOLICITED_STATUS, 0,
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_UNSOLICITED_STATUS,
+				  SBAL_SFLAGS0_TYPE_STATUS,
 				  adapter->pool.status_read_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);

