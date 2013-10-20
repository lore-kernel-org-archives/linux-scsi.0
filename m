From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] [SCSI] sg: late O_EXCL fix for lk 3.12-rc
Date: Sun, 20 Oct 2013 19:31:53 +0200
Message-ID: <52641389.6090604@acm.org>
References: <52640025.60709@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yahoo.smtp.stone-is.be ([5.134.1.31]:33233 "EHLO
	yahoo.smtp.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3JTRb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Oct 2013 13:31:58 -0400
In-Reply-To: <52640025.60709@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>

On 10/20/13 18:09, Douglas Gilbert wrote:
> Given that lk 3.12.0 release is not far away, the safest path
> may still be to revert Vaughan Cao's patch. I'll leave that
> decision to the maintainers.

Hello Doug,

Thanks for looking into this. But I would appreciate it if you could 
address the whitespace errors reported by checkpatch:

ERROR: space prohibited after that '!' (ctx:BxW)
#24: FILE: drivers/scsi/sg.c:241:
+		    (excl_case ? (! sdp->exclude) : sfds_list_empty(sdp))));
  		                  ^

ERROR: space prohibited after that '!' (ctx:BxW)
#55: FILE: drivers/scsi/sg.c:289:
+			if (! alone) {
  			    ^

ERROR: code indent should use tabs where possible
#59: FILE: drivers/scsi/sg.c:292:
+                        }$

WARNING: please, no spaces at the start of a line
#59: FILE: drivers/scsi/sg.c:292:
+                        }$

ERROR: space prohibited after that '!' (ctx:BxW)
#73: FILE: drivers/scsi/sg.c:301:
+			while (! alone) {
  			       ^

WARNING: suspect code indent for conditional statements (8, 12)
#144: FILE: drivers/scsi/sg.c:375:
+	if (excl || sfds_list_empty(sdp))
+	    wake_up_interruptible(&sdp->open_wait);

Thanks,

Bart.

