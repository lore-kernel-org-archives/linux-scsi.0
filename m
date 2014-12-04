From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] advansys: use shared host tag map for command
	lookup
Date: Thu, 4 Dec 2014 10:26:41 +0100
Message-ID: <20141204092641.GA24194@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-3-git-send-email-hare@suse.de> <20141204092043.GD23891@lst.de> <54802895.5010900@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57405 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaLDJ0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:26:43 -0500
Content-Disposition: inline
In-Reply-To: <54802895.5010900@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Thu, Dec 04, 2014 at 10:25:41AM +0100, Hannes Reinecke wrote:
> > Given that the tag has no meaning for the hardware why do you
> > want to endian switch it?  Keeping the ASC_VADDR for now makes
> > it easier to verify the hardware structures don't change.
> > 
> Mhm. See the patch I've just sent to Ondrej.
> For the narrow board it actually _has_ a meaning.
> But okay, the endian switch is probably pointless here.

Well, 0 vs non-0 isn't changed by endian conversion.  And the old
driver didn't do it either, so changing to and endianess conversion
needs to be documented, and preferably in a separate patch.

