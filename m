From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] Disallow changing the device state via sysfs into
 "deleted"
Date: Mon, 2 Sep 2013 12:17:31 -0700
Message-ID: <20130902191731.GA31438@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135C47.4090106@acm.org>
 <20130901164929.GD4344@infradead.org>
 <5224E012.6030907@acm.org>
 <20130902190645.GA18957@infradead.org>
 <5224E30F.9090605@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3IBTRv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 15:17:51 -0400
Content-Disposition: inline
In-Reply-To: <5224E30F.9090605@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Sep 02, 2013 at 09:12:15PM +0200, Bart Van Assche wrote:
> Hmm ... I think the second option would require to add an additional
> case in sdev_set_state() to avoid a compiler warning. This is
> something James objected against (on June 24, see also
> http://thread.gmane.org/gmane.linux.scsi/82572/focus=82576).

In that case the cast version seems fine to me.

