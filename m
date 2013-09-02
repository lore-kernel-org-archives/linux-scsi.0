From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv5 0/9] New EH command timeout handler
Date: Mon, 2 Sep 2013 01:27:28 -0700
Message-ID: <20130902082728.GA15554@infradead.org>
References: <1378105985-79686-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3IBI1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 04:27:37 -0400
Content-Disposition: inline
In-Reply-To: <1378105985-79686-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

One thing I'm still wondering is why we can't enable this globally,
and if there is a reason it should be documented.

As far as I can tell the actual calling context of the eh_abort_handler
doesn't change, so an LLDD would have to rely on some very specific
side effects of being in EH to break, and we never guaranteed such
specifics.

