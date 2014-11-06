From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] scsi: remove scsi_next_command
Date: Thu, 6 Nov 2014 16:34:13 +0100
Message-ID: <20141106153413.GA22415@lst.de>
References: <1415259630-20784-1-git-send-email-hch@lst.de> <1415259630-20784-3-git-send-email-hch@lst.de> <545B2F71.7020808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57552 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaKFPeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 10:34:16 -0500
Content-Disposition: inline
In-Reply-To: <545B2F71.7020808@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

On Thu, Nov 06, 2014 at 09:21:05AM +0100, Hannes Reinecke wrote:
> Hmm? Isn't there a scsi_put_comand() too many?
> You dropped it from the 'if' branch, moved it out of
> the condition, but kept in in the 'else' branch ...

The put_device for the 'else' branch was hidden inside scsi_next_command.

