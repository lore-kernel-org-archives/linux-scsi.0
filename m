From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2.4] export scsi_finish_command ACK?
Date: Tue, 23 Mar 2004 09:45:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40604D8F.6080505@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070401070203000303090703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58775 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262597AbUCWOps
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 09:45:48 -0500
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070401070203000303090703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Doug,

Can I get your ACK on the attached patch?

I am about to submit libata to Marcelo (again :)), and this export is 
needed by all users of ->eh_strategy_handler, of which libata is one.

	Jeff



--------------070401070203000303090703
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Tue Mar 23 09:43:29 2004
+++ b/drivers/scsi/scsi_syms.c	Tue Mar 23 09:43:29 2004
@@ -43,6 +43,7 @@
 EXPORT_SYMBOL(scsi_do_cmd);
 EXPORT_SYMBOL(scsi_command_size);
 EXPORT_SYMBOL(scsi_ioctl);
+EXPORT_SYMBOL(scsi_finish_command);
 EXPORT_SYMBOL(print_command);
 EXPORT_SYMBOL(print_sense);
 EXPORT_SYMBOL(print_req_sense);

--------------070401070203000303090703--

