From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Sun, 7 Sep 2014 09:24:06 -0700
Message-ID: <20140907162406.GA10775@infradead.org>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
 <1401953203-103015-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaIGQYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:24:08 -0400
Content-Disposition: inline
In-Reply-To: <1401953203-103015-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Robert Elliot <elliot@hp.com>, linux-scsi@vger.kernel.org

Looks like you put a version into the SuSE tree with a blacklist entry
just for the Fujitsu array that requires the TEST UNIT READY.  Can you
send that version upstream as well?

