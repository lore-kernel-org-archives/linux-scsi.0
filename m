From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Move scsi.h, hosts.h to include/linux/scsi ?
Date: Mon, 17 Feb 2003 14:07:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217130756.GA3510@mars.ravnborg.org>
References: <20030216211422.GD8572@mars.ravnborg.org> <20030217121840.A24543@infradead.org> <20030217125334.GA3346@mars.ravnborg.org> <20030217125821.A25189@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030217125821.A25189@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org

On Mon, Feb 17, 2003 at 12:58:21PM +0000, Christoph Hellwig wrote:
> > In general just combining all the stuff in a single scsi.h file
> > (the other alternative)  looks ugly to me.
> 
> Why?  If you think the current hosts.h make sense please explain
> me the rules on why stuff is in hosts.h instead of scsi.h..

It was just my first hand impressions that hosts.c had something to do
upper.h.
I have not looked into scsi before - and I'm not planning to that
except on a janitorial level. In other words I can do simple stuff
that moves definitions around, but I do not claim I understand the
SCSI subsystem. And I do not plan to invest the time needed to
understand it.
Hope that clarifies.

As I wrote in the previous mail, I'm not going to do any split-up as
you suggested. Simply because it would take much more time
understanding the SCSI subsystem than actually doing the split-up.

My only incentive is to avoid those ugly includes that requires an
extra option to gcc in my current kbuild patch for separate objdir.

	Sam
