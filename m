From: Dave Olien <dmo@osdl.org>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Tue, 12 Oct 2004 10:59:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012175943.GB27526@osdl.org>
References: <20041012000058.GA26569@osdl.org> <eada2a07041012092973d35415@mail.gmail.com> <20041012165919.GA27526@osdl.org> <1097601199.2044.91.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:62389 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266538AbUJLR7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 13:59:51 -0400
Content-Disposition: inline
In-Reply-To: <1097601199.2044.91.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


James,

On Tue, Oct 12, 2004 at 12:13:13PM -0500, James Bottomley wrote:
> 
> Hang on a minute ... if you're ping pong'ing the drives using AVT, those
> transfers take time to achieve.  The device is probably returning UNIT
> ATTENTION, NOT_READY while the transfer is in progress.  This is
> probably the source of the requeue.

	OK, This probably makes sense.  I'm going to see if I can
	get a theory of operations for this device somewhere.  I'd
	like to have a better understanding of how the device
	works and how long it takes to do these transfers.

> 
> As for the error, I still don't understand that, but it looks like
> something went wrong in setting up or tearing down the dma mapping, so
> that it was incorrectly described when this happened a second time.

	I'll dump out some more information about these cases, and
	see if we can analyze what's going on.
> 
> James
> 

Thanks!
Dave
