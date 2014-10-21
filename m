From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv7 00/27] scsi logging update (the boring part)
Date: Tue, 21 Oct 2014 04:04:34 -0700
Message-ID: <20141021110434.GA19714@infradead.org>
References: <1413787950-14659-1-git-send-email-hare@suse.de>
 <20141021105538.GA1950@infradead.org>
 <54463D58.60906@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaJULEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 07:04:35 -0400
Content-Disposition: inline
In-Reply-To: <54463D58.60906@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Oct 21, 2014 at 01:02:48PM +0200, Hannes Reinecke wrote:
> > What tree is this against?  This doesn't seem to touch the ufs driver,
> > which in 3.18-rc has grown calls to some of the functions you remove.
> > 
> Hmm. I _thought_ to have it done against core-for-3.18; but I'll
> double check ...

The core-for-3.18 tree indeed doesn't have this changes, but as 3.18-rc1
is out that doesn't really matter.  Please prepare it against Linus'
latest tree.  I will probably push out a core-for-3.19 today, but it
won't have a lot of patches at this point.
