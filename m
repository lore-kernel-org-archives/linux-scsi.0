From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] First batch of logging cleanups
Date: Tue, 03 Jun 2014 18:12:35 -0400
Message-ID: <yq11tv54p7w.fsf@sermon.lab.mkp.net>
References: <1401794577-102277-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32426 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045AbaFCWNK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 18:13:10 -0400
In-Reply-To: <1401794577-102277-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 3 Jun 2014 13:22:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, this is the first patch of my SCSI logging cleanup.  The
Hannes> basic idea here is to use dev_printk() and friends throughout
Hannes> the midlayer, so that any logging messages are attached with the
Hannes> correct device information.

All patches look good to me (except I'd really like to see SCSI logging
die a horrible death. Sadly it's an exposed user interface and therefore
hard to nuke).

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
