From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Fri, 15 Jun 2012 12:00:32 +0100
Message-ID: <20120615120032.235648f1@pyramind.ukuu.org.uk>
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59293 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab2FOK5E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jun 2012 06:57:04 -0400
In-Reply-To: <1339757457-15646-1-git-send-email-jack@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>

On Fri, 15 Jun 2012 12:50:57 +0200
Jan Kara <jack@suse.cz> wrote:

> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: James Bottomley <JBottomley@parallels.com>
> CC: linux-scsi@vger.kernel.org
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Alan Cox <alan@linux.intel.com>

