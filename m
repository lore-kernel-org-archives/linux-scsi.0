From: Jeff Garzik <jgarzik@pobox.com>
Subject: "do ata" scsi command?
Date: Thu, 15 May 2003 19:02:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030515230223.GA516@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:33186
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S264283AbTEOWtc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 18:49:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In terms of a userspace interface for my ata-over-scsi gadget, I would
prefer to use /dev/sg instead of inventing a totally new interface.
That, in turn, implies a need for a "do ata taskfile" scsi command,
which is sorta like ATAPI in reverse:  we are wrapping a raw ata
taskfile inside a scsi cdb.

My question is, does an existing standard or spec exist for such an idea?

If not, I'll just roll my own.

Thanks,

	Jeff



