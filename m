From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/20] scsi: stop decoding if scsi_normalize_sense() fails
Date: Fri, 5 Sep 2014 17:04:13 -0700
Message-ID: <20140906000413.GC29588@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIFABy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:01:54 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:01PM +0200, Hannes Reinecke wrote:
> If scsi_normalize_sense() fails we couldn't decode the sense
> buffer, and the scsi_sense_hdr fields are invalid.
> For those cases we should rather dump the sense buffer
> and not try to decode invalid fields.

This description still doesn't make sense to me.  What you describe
is both old and new behavior, you just dump the raw buffer differently.

