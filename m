From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 13:32:23 -0700 (PDT)
Message-ID: <624919.2254.qm@web31810.mail.mud.yahoo.com>
References: <1182521500.3923.49.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:20660 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751779AbXFYUjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 16:39:05 -0400
In-Reply-To: <1182521500.3923.49.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Thu, 2007-06-21 at 21:40 -0700, Mike Anderson wrote:
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > > A proposal to display the correct form of the LUN would be useful if you
> > > wish to make it? ...  The problem is really that SAM specifies a
> > > possible 4 level structure with 4 possible address methods per level.
> > > 
> > > The well known LUNs should be simple; there are only three: Report Lun,
> > > Access Controls and Target Log Pages.  The rest we really need input on.
> > > For instance, I could see the vendors wishing us to combine a
> > > multi-level flat addressing space into a single logical unit number,
> > > whereas I could see them wanting us to supply some sort of hierarchy for
> > > the peripheral and logical unit methods of addressing.
> > > 
> > > Since you're already using 2 level flat addressing, how do you want to
> > > see that represented?

Goodness gracious!

> > 
> > James, why would we would not want to display the lun per SAM4 4.6.2 as
> > suggested by Stefan in a previous comment.
> 
> Because in a two LUN system, what was LUN 1 would then become LUN
> 0x1000000000000 which looks a bit unpalatable.

To whom?  Who (as in entity) is the audience of the (structure of a) LUN?

    Luben

