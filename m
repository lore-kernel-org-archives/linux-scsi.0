From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/7] scsi: storvsc: Miscellaneous enhancements and fixes
Date: Mon, 23 Mar 2015 14:06:00 -0700
Message-ID: <1427144760-11875-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53589
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbbCWTtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2015 15:49:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

This patch-set addresses perf issues discovered on the Azure storage stack.
These patches also fix a couple of bugs.

K. Y. Srinivasan (7):
  scsi: storvsc: Increase the ring buffer size
  scsi: storvsc: Size the queue depth based on the ringbuffer size
  scsi: storvsc: Always send on the selected outgoing channel
  scsi: storvsc: Retrieve information about the capability of the
    target
  scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
  scsi: storvsc: Don't assume that the scatterlist is not chained
  scsi: storvsc: Set the tablesize based on the information given by
    the host

 drivers/scsi/storvsc_drv.c |  231 ++++++++++++++++++++++++++++----------------
 1 files changed, 149 insertions(+), 82 deletions(-)

-- 
1.7.4.1

