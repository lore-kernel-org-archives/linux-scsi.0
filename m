From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: 18 Sep 2004 15:12:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095534778.2483.8.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
	<1095465337.1944.3.camel@mulgrave>
	<20040918011510.GA31628@praka.san.rr.com>
	<20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1665 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268854AbUIRTNW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 15:13:22 -0400
In-Reply-To: <20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jeremy Higdon <jeremy@sgi.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Fri, 2004-09-17 at 21:25, Matthew Wilcox wrote:
> But the write that starts the reset can be delayed arbitrarily, so we need
> to do *some* kind of read from the device to be know that it got there.
> Can we access config space instead of mmio space?

This was my worry as well.  I think if there's no way to flush the
posted write then you need to activate this reset by PIO which doesn't
suffer from posting.

James


