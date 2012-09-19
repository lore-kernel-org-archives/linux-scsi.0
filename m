From: Brian Candler <B.Candler@pobox.com>
Subject: Fix for freeze on SATA hotplug
Date: Wed, 19 Sep 2012 08:01:57 +0000
Message-ID: <20120919080157.GA34192@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:53117 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2ISIB7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2012 04:01:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

I had an issue where a failing drive which generated SATA hotplug events
caused the whole I/O subsystem to deadlock.

Jack Wang on the gluster-users mailing list identified the problem as a
regression, and gave me a patch which has successfully fixed it:
http://gluster.org/pipermail/gluster-users/2012-September/011355.html

However, I see this patch is not in mainline kernel yet. Has any progress
been made towards this, e.g. including it in subsystem maintainer's tree?

Thanks,

Brian.

P.S. Original problem description at
http://gluster.org/pipermail/gluster-users/2012-September/011354.html

The issue is now also recorded at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1049013
since it exists in Ubuntu kernel 3.2.0-30
