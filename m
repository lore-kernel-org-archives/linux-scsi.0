From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [PATCH 0/8] qla4xxx: new driver -- request for review.
Date: Thu, 27 Oct 2005 13:31:21 -0500
Message-ID: <200510271831.j9RIVL3S024752@falcon30.maxeymade.com>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:30167 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S1751292AbVJ0Sbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 14:31:36 -0400
In-reply-to: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>


On Tue, 06 Sep 2005 15:08:41 PDT, Andrew Vasquez wrote:
>All,
>
>Here's a first-pass run for submission-review of the qla4xxx driver for
>QLogic's ISP4010 and ISP4022 products.
>
>The patchset breaks-down as follows:
>
>o Driver definitions
>o initialisation routines
>o OS integration files
>o iSNS routines
>o ISR routines
>o Mailbox routines
>o Support routines
>o Settings
>
>There's still quite a bit of work to do:
>
>- All command-queueing has been removed, so cable-pulls cannot be
>  tolerated.  We need to complete the iSCSI transport integration
>  (which seems to no be present).
>
>  Are the iSCSI block()/unblock() routines moving forward similarly to
>  FC and now SAS?  Mike Christie had submitted patches:
>
>	[PATCH] add block/unblock to iscsi class
>	http://marc.theaimsgroup.com/?l=linux-scsi&m=111201856631844&w=2
>
>  some time back.  Why were the patches dropped?
>
>- Request-queue management cleanup
>
>- iSNS code rework
>
>- Additional cruft removal (unused structures and functions)
>
>
>All patches can be found at the following URL:
>
>	ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.03b15-k/
>
>Comments and criticisms welcomed.

Any new patches in the pipeline?  

Looking for volunteers?

++doug

