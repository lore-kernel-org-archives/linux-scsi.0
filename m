From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Tue, 6 Nov 2007 11:09:51 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711061107480.21836@localhost.localdomain>
References: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
 <20071106153012.GG4113@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:48242 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXKFQLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 11:11:46 -0500
In-Reply-To: <20071106153012.GG4113@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 6 Nov 2007, Matthew Wilcox wrote:

> On Tue, Nov 06, 2007 at 10:20:46AM -0500, Robert P. J. Day wrote:
> > @@ -1656,7 +1657,7 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
> >  	if(!(it & me))
> >  		return -1;
> >  	it &= ~me;
> > -	if(it & (it - 1))
> > +	if(!is_power_of_2(it))
> >  		return -1;
>
> Non-equivalent transform.  Probably a bug.
>
> >  		bits &= ~esp->scsi_id_mask;
> > -		if (!bits || (bits & (bits - 1)))
> > +		if (!is_power_of_2(bits))
> >  			goto do_reset;
>
> Non-equivalent transform.  Definitely a bug.

ok, that one i'm curious about.  how is that not an equivalent
transform?  am i missing something painfully obvious?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
