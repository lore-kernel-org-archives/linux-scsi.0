From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sym53c8xx in 2.6.12-rc6: sleeping function called from invalid
	context at mm/slab.c:2093
Date: Fri, 17 Jun 2005 09:16:29 -0500
Message-ID: <1119017789.5049.16.camel@mulgrave>
References: <m33brlfi4e.fsf@merlin.emma.line.org>
	 <20050617112907.GH11655@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:34762 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261983AbVFQOQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 10:16:44 -0400
In-Reply-To: <20050617112907.GH11655@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthias Andree <matthias.andree@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@zip.com.au>

On Fri, 2005-06-17 at 12:29 +0100, Matthew Wilcox wrote:
> Fixed in sym2 2.2.1 which was sent to this list on May 20th.  I'm a little
> unhappy that it's been 4 weeks and it's not included, particularly since
> it includes some important regression fixes.

Well, look at it from my point of view ... a complete driver revision
with enhancements and bug fixes is potentially destabilising so it can't
go in to a *real* rc (unless you split out the bug fixes).

My real beef is that I can't tell when a real rc actually is.  I've
already concluded that -rc1 to -rc3 are the "We're only joking you can
still do full feature re-writes".  However, your patch arrived at -rc4
which is the point I think we're getting to the "we might actually mean
this is a rc" phase.

James


