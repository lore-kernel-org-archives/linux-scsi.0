From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_track_queue_full function - static values ?
Date: Fri, 10 Mar 2006 16:40:27 +0000
Message-ID: <20060310164027.GA6397@infradead.org>
References: <440D8B7C.9020001@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51148 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751829AbWCJQka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 11:40:30 -0500
Content-Disposition: inline
In-Reply-To: <440D8B7C.9020001@ext.bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Cc: linux-scsi@vger.kernel.org, dledford@redhat.com

On Tue, Mar 07, 2006 at 02:32:44PM +0100, Frederic TEMPORELLI wrote:
> I was looking at the scsi_track_queue_full (driver/scsi/scsi.c) function.
> 
> Can someone tell me how have been defined all the static values in this 
> function ?
> 
> - we may have (max) 16 (>>4) jiffies between calls (else there's no need to 
> call this function...),
> 
> - queue_full_depth_count should be > 10 (else queue depth still not 
> changed),
> 
> - if lun queue depth < 8, lun queue depth is set with cmd_per_lun
> (what's happen if cmd_per_lun > 8 ???)
> 
> 
> May someone add some #define for these values ?
> Is it a way to use 'auto-adapted' values ?

I think Doug Ledford wrote that code, I've added him to the cc list
as he's probably the best one to answer your question.

While we're at it, it would be nice if more drivers used this functionality..

