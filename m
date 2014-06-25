From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Possible use after free in scsi_put_command()?
Date: Wed, 25 Jun 2014 02:01:15 -0700
Message-ID: <20140625090115.GA21045@infradead.org>
References: <53A99420.3080503@redhat.com>
 <53AA719C.6030204@acm.org>
 <53AA7432.9030709@redhat.com>
 <53AA7E03.5070407@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbaFYJBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 05:01:21 -0400
Content-Disposition: inline
In-Reply-To: <53AA7E03.5070407@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Maurizio Lombardi <mlombard@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jun 25, 2014 at 09:45:07AM +0200, Bart Van Assche wrote:
> Hello James and Christoph,
> 
> Is it correct that the patch mentioned above has not yet been queued up
> ? Has it already been decided in which kernel version that patch should
> be included ?

I've got it in my local pending queue for 3.17.  I'll push that one out
soon.

