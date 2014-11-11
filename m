From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] scsi: remove scsi_next_command
Date: Tue, 11 Nov 2014 17:37:48 +0100
Message-ID: <20141111163748.GA13445@lst.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-3-git-send-email-hch@lst.de> <545B2F71.7020808@suse.de> <20141106153413.GA22415@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39186 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaKKQhw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2014 11:37:52 -0500
Content-Disposition: inline
In-Reply-To: <20141106153413.GA22415@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

On Thu, Nov 06, 2014 at 04:34:13PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 06, 2014 at 09:21:05AM +0100, Hannes Reinecke wrote:
> > Hmm? Isn't there a scsi_put_comand() too many?
> > You dropped it from the 'if' branch, moved it out of
> > the condition, but kept in in the 'else' branch ...
> 
> The put_device for the 'else' branch was hidden inside scsi_next_command.

Is this a good enough explanation to get a Reviewed-by?

