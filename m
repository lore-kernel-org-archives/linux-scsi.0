From: akpm@linux-foundation.org
Subject: [patch 21/26] bfa: wrong fcport H2I message tested in bfa_fcport_isr()
Date: Mon, 24 May 2010 12:22:36 -0700
Message-ID: <201005241922.o4OJMaMx011345@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab0EXTWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2010 15:22:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, huangj@Brocade.COM

From: Roel Kluin <roel.kluin@gmail.com>

It appears that the wrong fcport H2I message was tested

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jing Huang <huangj@Brocade.COM>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfa_fcport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/bfa/bfa_fcport.c~bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr drivers/scsi/bfa/bfa_fcport.c
--- a/drivers/scsi/bfa/bfa_fcport.c~bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr
+++ a/drivers/scsi/bfa/bfa_fcport.c
@@ -1281,7 +1281,7 @@ bfa_fcport_isr(struct bfa_s *bfa, struct
 		break;
 
 	case BFI_FCPORT_I2H_DISABLE_RSP:
-		if (fcport->msgtag == i2hmsg.penable_rsp->msgtag)
+		if (fcport->msgtag == i2hmsg.pdisable_rsp->msgtag)
 			bfa_sm_send_event(fcport, BFA_FCPORT_SM_FWRSP);
 		break;
 
_
