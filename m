From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Where to post actual h/w issue questions?
Date: Wed, 1 Sep 2004 08:06:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040901130644.GB5621@lists.us.dell.com>
References: <6.1.0.6.1.20040901085756.00b37330@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:46453 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266473AbUIANG7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 09:06:59 -0400
Content-Disposition: inline
In-Reply-To: <6.1.0.6.1.20040901085756.00b37330@localhost>
List-Id: linux-scsi@vger.kernel.org
To: John Mason <john@mmspos.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 01, 2004 at 09:00:33AM -0300, John Mason wrote:
> 
> I joined the list last week and most of the discussion here seems to be 
> related to patches to various drivers and kernels.  I've only seen one post 
> other than my own about a hardware or driver failure (on a Dell with 
> megaraid), so is there another list I should be asking on?

Hardware failures are best handled by the tech support organization of
the company who you purchased the hardware from.

If it's not truly a hardware failure, but an interaction of their
device driver with the hardware, and the driver is part of the
standard kernel.org kernels, then sure, this list is a good place to
ask.  megaraid is a good example.  The driver is developed and
discussed on this list, anything about the driver is fair game on this
list.  But most people on this list don't have megaraid hardware, so
if it's hardware specific, and the LSI guys don't answer immediately,
and its a failure of a "supported" product, you'll need to contact
their technical support org.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
