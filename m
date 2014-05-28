From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_lib: replace ambiguous "Unhandled error code"
 messages.
Date: Wed, 28 May 2014 04:00:18 -0700
Message-ID: <20140528110018.GA30751@infradead.org>
References: <1401099204-18050-1-git-send-email-mlombard@redhat.com>
 <20140526162506.GB18319@infradead.org>
 <20140526192715.GA2271@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaE1LAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 07:00:18 -0400
Content-Disposition: inline
In-Reply-To: <20140526192715.GA2271@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, May 26, 2014 at 09:27:15PM +0200, Maurizio Lombardi wrote:
> > How about simple not setting description at all for this case?
> > 
> 
> It has already been proposed before but James didn't like the idea.
> 
> http://markmail.org/message/dumujpz4gfp3s4fp#query:+page:1+mid:dumujpz4gfp3s4fp+state:results

James never replied to Robs question.  I can't think of any value add
that "Unhandled XYZ" adds when we already get a usesul message from the
same error.

James, care to comment what'd you like to see printed here?

