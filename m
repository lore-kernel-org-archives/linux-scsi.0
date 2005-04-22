From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [6/5]  qla2xxx: update version :)
Date: Fri, 22 Apr 2005 00:22:00 -0700
Message-ID: <20050422072200.GD5069@plap.qlogic.org>
References: <20050413205007.GA14857@plap.qlogic.org> <1113425828.4933.39.camel@mulgrave> <20050413212436.GC14857@plap.qlogic.org> <20050419211519.GB20234@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:730 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262004AbVDVHWC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 03:22:02 -0400
Content-Disposition: inline
In-Reply-To: <20050419211519.GB20234@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 19 Apr 2005, Christoph Hellwig wrote:

> On Wed, Apr 13, 2005 at 02:24:36PM -0700, Andrew Vasquez wrote:
> > Ok, here's the deal -- QLogic's standard 8.01.00 driver contains the
> > following major additions:
> > 
> > * support for 4Gb ISPs
> > * FCIP support
> 
> Btw, any plans to do proper FCIP support integrated with the transport
> class code?
>

Ok, I'll bite (since this is the second time I've heard about FCIP
being 'integrated' with the transport classes) -- what did you have in
mind?  There's already a clear set of mature networking interface with
which a networking card's driver uses to interface with the stack.

Are you looking to generalize those interfaces
(open/hard_xmit/stop/etc.) into helpers transport helpers?

>
> (and finally fixing the damn NAA bug violating RFC 2625 ;-))
> -

Yes, I'll see what I can do from this side on getting this addressed
once and for all.

--
av
