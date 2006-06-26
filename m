From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH] Fix bug: accessing past end of array.
Date: Sun, 25 Jun 2006 20:18:05 -0700 (PDT)
Message-ID: <20060626031805.41634.qmail@web50412.mail.yahoo.com>
References: <20060625192827.730f1a8d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web50412.mail.yahoo.com ([206.190.38.155]:45705 "HELO
	web50412.mail.yahoo.com") by vger.kernel.org with SMTP
	id S1751412AbWFZDSG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 23:18:06 -0400
In-Reply-To: <20060625192827.730f1a8d.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

--- "Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> [adding linux-scsi]
> 
> On Sun, 25 Jun 2006 19:06:46 -0700 (PDT) Alex Davis wrote:
> 
> > If the card is re-inserted 2 or more times, we access elements
> > past the end of the aha152x_host array.
> 
> When I was testing/reproducing this, I observed that removing
> the card did not cause the aha152x_detach() function to be called
> (in drivers/scsi/pcmcia/aha152x_stub.c).  However, I didn't
> find out why that doesn't happen.  I think fixing this would
> be a big help.
> 
Strange. I'm not having that problem. I even added a printk to verify.
I get the following in my logs:

[4295091.671000] pccard: card ejected from slot 0
[4295091.671000] aha152x_detach(0xd8877600)       <-----added printk.



> > Also correct spelling errors.
> > 
> > This is for 2.6.17.
> > 
> > Signed-off-by Alex Davis <alex14641 at yahoo dot com>
> > =========================================================================
> > diff -u linux-2.6.17.1-orig/drivers/scsi/aha152x.c linux-2.6.17.1/drivers/scsi/aha152x.c
[snip]

I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
