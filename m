From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: scsi scan
Date: Thu,  3 Nov 2011 13:29:02 -0700
Message-ID: <1320352142-30592-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51582
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751016Ab1KCUD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2011 16:03:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, hch@infradead.org, kys@microsoft.com

James,

On the Windows host they allow hot add/remove of block devices attached to the scsi controller(s) assigned to the guest.
So, when a hot add/remove event occurs, the host sends a message to the guest that something has changed on the hba and
the guest is responsible for figuring out what has changed: a) Setup state to manage new devices that may have been added
and b) get rid of devices that may have been removed. As I look at implementing this functionality for Linux guests,
I would need to be able to do a scan on the hba under question and deal only with whatever has changed.
Is this something that the scsi core supports or would I need to roll out a version of scan that would ignore
devices already scanned (except for the remove case) and properly add new devices that may be found.
Any guidance here would be greatly appreciated.

Regards,

K. Y

