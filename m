From: Christoph Hellwig <hch@lst.de>
Subject: Re: PR API fixes for multipathing
Date: Sat, 16 Jul 2016 03:08:44 +0200
Message-ID: <20160716010844.GA29087@lst.de>
References: <1467980631-18945-1-git-send-email-hch@lst.de> <yq1y452iuzp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41066 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbcGPBIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 21:08:46 -0400
Content-Disposition: inline
In-Reply-To: <yq1y452iuzp.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Jul 15, 2016 at 03:03:54PM -0400, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> I was a bit overeager to thing ALL_TG_PT would solve all our
> Christoph> multipathing woes in respect to persistent reservation.
> Christoph> Turns out that there are lots of possible setups where it
> Christoph> doesn't work, and we'll have to ask device mapper to register
> Christoph> all underlying devices instead.
> 
> Should I queue the sd patch or let Mike take both through the DM tree?

I think having both in the same tree would be very useful.  I don't care
which one that is.
