From: akpm@linux-foundation.org
Subject: [patch 1/2] drivers/message/fusion/mptscsih.c: missing break
Date: Thu, 08 Nov 2012 16:12:01 -0800
Message-ID: <20121109001202.0D832100049@wpzn3.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59603 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2KIAME (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2012 19:12:04 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so404001vbi.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Nov 2012 16:12:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alan@linux.intel.com, kashyap.desai@lsi.com, nagalakshmi.nandigama@lsi.com

From: Alan Cox <alan@linux.intel.com>
Subject: drivers/message/fusion/mptscsih.c: missing break

This happens to do the right thing in all cases on fibre channel but not on
other media types

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/message/fusion/mptscsih.c~drivers-message-fusion-mptscsihc-missing-break drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~drivers-message-fusion-mptscsihc-missing-break
+++ a/drivers/message/fusion/mptscsih.c
@@ -792,6 +792,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			 * than an unsolicited DID_ABORT.
 			 */
 			sc->result = DID_RESET << 16;
+			break;
 
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			if (ioc->bus_type == FC)
_
