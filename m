From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 18:53:36 +0200
Message-ID: <20060414165336.GB4053@mars.ravnborg.org>
References: <20060414092911.71f25ac1.rdunlap@xenotime.net> <1145033415.3520.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtp.tele.dk ([193.162.159.95]:59400 "EHLO pasmtp.tele.dk")
	by vger.kernel.org with ESMTP id S1751284AbWDNQxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 12:53:54 -0400
Content-Disposition: inline
In-Reply-To: <1145033415.3520.36.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, scsi <linux-scsi@vger.kernel.org>

On Fri, Apr 14, 2006 at 11:50:15AM -0500, James Bottomley wrote:
> On Fri, 2006-04-14 at 09:29 -0700, Randy.Dunlap wrote:
> > WARNING: drivers/scsi/3w-9xxx.o - Section mismatch: reference to .init.data: from .data between 'twa_driver' (at offset 0x18) and 'twa_error_table'
> > WARNING: drivers/scsi/3w-xxxx.o - Section mismatch: reference to .init.data: from .data between 'tw_driver' (at offset 0x18) and 'tw_sense_table'
> > WARNING: drivers/scsi/gdth.o - Section mismatch: reference to .init.text:gdth_detect from .data between 'driver_template' (at offset 0x270) and 'async_cache_tab'
> > 
> > I either don't see a problem or I'm having trouble reading/decoding
> > the warning messages.  Could you look at these 3 sometime?
> 
> These seem to have been turning up all over the tree.  The only common
> feature seems to be that if you re-run the build, they don't show up
> again.

I really hope this is not true. The reporting ought to be conistent.
If you can give me something reproduceable then I will try to hunt it
down.

	Sam
