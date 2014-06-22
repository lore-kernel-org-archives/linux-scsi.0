From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 32-bit bug in iovec iterator changes
Date: Sun, 22 Jun 2014 07:50:07 -0400
Message-ID: <20140622115007.GA5333@thunk.org>
References: <20140619223820.GN4453@dastard>
 <20140621035144.GA8526@thunk.org>
 <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
 <20140622002618.GR18016@ZenIV.linux.org.uk>
 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
 <20140622005352.GS18016@ZenIV.linux.org.uk>
 <20140622010032.GT18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51770 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaFVLuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2014 07:50:16 -0400
Content-Disposition: inline
In-Reply-To: <20140622010032.GT18016@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Jun 22, 2014 at 02:00:32AM +0100, Al Viro wrote:
> 
> PS: I agree that it's worth careful commenting, obviously, but
> before sending it to Linus (*with* comments) I want to get a
> confirmation that this one-liner actually fixes what Ted is seeing.
> I have reproduced it here, and that change makes the breakage go
> away in my testing, but I'd like to make sure that we are seeing the
> same thing.  Ted?

Hep, that fixes things.  Thanks for explaining what was going on!

     	  		 	    	       - Ted
