From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/6] scsi: storvsc: Some miscellaneous cleanup
Date: Fri, 29 May 2015 13:28:56 -0700
Message-ID: <1432931336-14434-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41094
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbbE2TH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 May 2015 15:07:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Cleanup version handling as well as base feature detection on storage
version as opposed to host version.

keith.mange@microsoft.com (6):
  scsi: storvsc: Rather than look for sets of specific protocol
    versions, make decisions based on ranges.
  scsi: storvsc: Use a single value to track protocol versions
  hv:scsi:Untangle the storage protocol negotiation from the vmbus
    protocol negotiation.
  scsi: storvsc: use correct defaults for values determined by protocol
    negotiation
  scsi: storvsc: use storage protocol version to determine storage
    capabilities
  scsi: storvsc: Allow write_same when host is windows 10

 drivers/scsi/storvsc_drv.c |  194 ++++++++++++++++++++++++++++----------------
 1 files changed, 123 insertions(+), 71 deletions(-)

-- 
1.7.4.1

