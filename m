From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Tue, 11 Feb 2014 06:01:48 -0800
Message-ID: <20140211140148.GA1897@infradead.org>
References: <1384173897-103836-1-git-send-email-hare@suse.de>
 <1384173897-103836-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50158 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBKOB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2014 09:01:59 -0500
Content-Disposition: inline
In-Reply-To: <1384173897-103836-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Christoph Hellwig <hch@infradead.org>

Hi Hannes,

I'll need a little reminder how we came to the conclusion that the
cancel_delayed_work in scsi_put_command was safe and we didn't need
a cancel_delayed_work_sync or flush_delayed_work.  I remember we had
that discussion, but it seems that same doesn't apply to the equivalent
call in the blk-mq codepath in my tree.  If you remember anything that
might make my life debugging this a bit easier.

