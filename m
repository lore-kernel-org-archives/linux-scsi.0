From: jgross@suse.com
Subject: Add XEN pvSCSI support
Date: Fri, 27 Jun 2014 16:34:32 +0200
Message-ID: <1403879676-25431-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0OfA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 10:35:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org

This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
SCSI devices from a XEN domain.

The support consists of a backend in the privileged Domain-0 doing the real
I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.

The code is taken (and adapted) from the original pvSCSI implementation done
for Linux 2.6 in 2008 by Fujitsu.

[PATCH 1/4] Add XEN pvSCSI protocol description
[PATCH 2/4] Introduce xen-scsifront module
[PATCH 3/4] Introduce XEN scsiback module
[PATCH 4/4] add xen pvscsi maintainer
