From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Move scsi.h, hosts.h to include/linux/scsi ?
Date: Mon, 17 Feb 2003 12:58:21 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217125821.A25189@infradead.org>
References: <20030216211422.GD8572@mars.ravnborg.org> <20030217121840.A24543@infradead.org> <20030217125334.GA3346@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030217125334.GA3346@mars.ravnborg.org>; from sam@ravnborg.org on Mon, Feb 17, 2003 at 01:53:34PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org

On Mon, Feb 17, 2003 at 01:53:34PM +0100, Sam Ravnborg wrote:
> > 	include/scsi/upper.h
> 
> How much does upper.h differ from the current hosts.h?

upper is for the upper layer drivers (sd, sr, ...).  So there's
not much in common - this is what the HBA's don't need.

> In general just combining all the stuff in a single scsi.h file
> (the other alternative)  looks ugly to me.

Why?  If you think the current hosts.h make sense please explain
me the rules on why stuff is in hosts.h instead of scsi.h..

> > plus a drivers/scsi/scsiP.h for stuff private to the midlayer.
> But then the usage is restricted to users in drivers/scsi - and
> not anything living in arch/* - OK?

Yes, it's the stuff private to the scsi midlayer (scsi_*.c, hosts.c),
i.e. everything not exported to modules.

