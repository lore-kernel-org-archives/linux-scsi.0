From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] scsi: make eh_eflags persistent
Date: Thu, 3 Dec 2015 17:55:42 +0100
Message-ID: <20151203165542.GC14775@lst.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de> <1449127063-94512-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35685 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbbLCQzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 11:55:43 -0500
Content-Disposition: inline
In-Reply-To: <1449127063-94512-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, Dec 03, 2015 at 08:17:41AM +0100, Hannes Reinecke wrote:
> To detect if a failed command has been retried we must not
> clear scmd->eh_eflags when EH finishes.
> The flag should be persistent throughout the lifetime
> of the command.

So we save away eh_eflags before potentially reusing the command and
the restore it.  Seems seems fine, but an explanation of what this
fixes would be very helpful as the behavior seems to be around basically
forever.
