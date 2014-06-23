From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [regression] fix 32-bit breakage in block device read(2) (was
 Re: 32-bit bug in iovec iterator changes)
Date: Mon, 23 Jun 2014 11:43:02 -0400
Message-ID: <20140623154302.GC14887@thunk.org>
References: <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
 <20140622002618.GR18016@ZenIV.linux.org.uk>
 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
 <20140622005352.GS18016@ZenIV.linux.org.uk>
 <20140622010032.GT18016@ZenIV.linux.org.uk>
 <20140622115007.GA5333@thunk.org>
 <20140623074440.GV18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53444 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbaFWPnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2014 11:43:09 -0400
Content-Disposition: inline
In-Reply-To: <20140623074440.GV18016@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 23, 2014 at 08:44:40AM +0100, Al Viro wrote:
> 
> OK, here it is, hopefully with sufficient comments:

The comments look really good.  I assume you'll get this to
Linus in time for 3.16-rc3?

Many thanks!!

					- Ted
